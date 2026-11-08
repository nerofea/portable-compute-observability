"""Native host telemetry. Missing hardware sensors are reported as unavailable."""
import csv,math,os,pathlib,platform,re,shutil,subprocess,sys,time
def command(args,timeout=2):
 try:
  p=subprocess.run(args,capture_output=True,text=True,timeout=timeout)
  return p.stdout if p.returncode==0 else None
 except (OSError,subprocess.TimeoutExpired):return None
def capabilities():
 mac=sys.platform=="darwin"
 return {"platform":platform.platform(),"vm_stat":mac and bool(shutil.which("vm_stat")),"memory_pressure":mac and bool(shutil.which("memory_pressure")),"powermetrics_available":mac and bool(shutil.which("powermetrics")),"powermetrics_requires_privilege":mac,"metal_gpu_counters":"requires Instruments/Xcode; not sampled" if mac else "not applicable","nvidia_smi":bool(shutil.which("nvidia-smi")),"external_power_csv":"optional unix_ns,power_watts,source","energy_scope":"whole process, external sensor only"}
def sample():
 result={"unix_ns":time.time_ns(),"monotonic_ns":time.monotonic_ns(),"load_average":os.getloadavg() if hasattr(os,"getloadavg") else None}
 if sys.platform=="darwin":
  vm=command(["vm_stat"])
  if vm:
   page=re.search(r"page size of (\d+) bytes",vm)
   result["vm_stat"]={"page_size_bytes":int(page.group(1)) if page else 4096,"pages":{k.strip():int(v) for k,v in re.findall(r"^([^:\n]+):\s*(\d+)\.",vm,re.M)}}
  pressure=command(["memory_pressure","-Q"])
  if pressure:
   m=re.search(r"System-wide free memory percentage:\s*([\d.]+)",pressure)
   if m:result["free_memory_percent"]=float(m.group(1))
 elif sys.platform=="linux":
  try:
   data=pathlib.Path("/proc/meminfo").read_text()
   result["memory_kib"]={k:int(v) for k,v in re.findall(r"^(MemTotal|MemAvailable|SwapFree):\s*(\d+) kB",data,re.M)}
  except OSError:pass
 if shutil.which("nvidia-smi"):
  raw=command(["nvidia-smi","--query-gpu=utilization.gpu,memory.used,power.draw,temperature.gpu","--format=csv,noheader,nounits"])
  if raw:
   try:result["nvidia"]=[dict(zip(("gpu_util_percent","memory_mib","power_w","temperature_c"),[float(x.strip()) for x in line.split(",")])) for line in raw.strip().splitlines()]
   except ValueError:pass
 return result
def read_power_csv(path):
 if not path:return []
 with open(path,newline="") as f:rows=list(csv.DictReader(f))
 result=[]
 for r in rows:
  t=int(r["unix_ns"]);w=float(r["power_watts"])
  if t<=0 or not math.isfinite(w) or w<0 or (result and t<=result[-1][0]):raise ValueError("Invalid power sample")
  result.append((t,w,r.get("source","external")))
 return result
def integrate_power(samples,start_ns,end_ns,max_gap_ns=5_000_000_000):
 if len(samples)<2 or end_ns<=start_ns or start_ns<samples[0][0] or end_ns>samples[-1][0]:return None
 if any(y-x>max_gap_ns for (x,_,_),(y,_,_) in zip(samples,samples[1:]) if y>=start_ns and x<=end_ns):return None
 def at(t):
  for (x,p,_),(y,q,_) in zip(samples,samples[1:]):
   if x<=t<=y:return p+(q-p)*(t-x)/(y-x)
  return None
 points=[(start_ns,at(start_ns))]+[(t,p) for t,p,_ in samples if start_ns<t<end_ns]+[(end_ns,at(end_ns))]
 return sum((y-x)*(p+q)*0.5e-9 for (x,p),(y,q) in zip(points,points[1:]))
def summarize_resource_file(path):
 import json
 rows=[json.loads(line) for line in pathlib.Path(path).read_text().splitlines() if line.strip()]
 values=[r["free_memory_percent"] for r in rows if isinstance(r.get("free_memory_percent"),(float,int))]
 return {"sample_count":len(rows),"sampling_scope":"system, not isolated workload","free_memory_percent_min":min(values) if values else None}
