#!/usr/bin/env python3
"""Run bounded, sequential backend experiments; preserve raw artifacts and unavailable status."""
import argparse,csv,datetime,html,json,os,pathlib,platform,shutil,statistics,subprocess,sys,threading,time,uuid
ROOT=pathlib.Path(__file__).resolve().parents[2]
import native_telemetry as telemetry
POWER_SAMPLES=[]
def command(cmd,timeout=10):
 try:
  p=subprocess.run(cmd,cwd=ROOT,text=True,capture_output=True,timeout=timeout)
  return p.stdout.strip() if p.returncode==0 else None
 except (OSError,subprocess.TimeoutExpired):return None
def environment():
 return {"platform":platform.platform(),"machine":platform.machine(),"python":sys.version,"git_commit":command(["git","rev-parse","HEAD"]),"rustc":command(["rustc","-Vv"]),"swiftc":command(["swiftc","--version"]),"gpu":command(["system_profiler","SPDisplaysDataType"],20) if sys.platform=="darwin" else command(["nvidia-smi","-L"]),"memory_bytes":command(["sysctl","-n","hw.memsize"]) if sys.platform=="darwin" else None}
def resources():
 out={"unix_ns":time.time_ns(),"load_average":os.getloadavg() if hasattr(os,"getloadavg") else None}
 if sys.platform=="darwin":
  out["vm_stat"]=command(["vm_stat"],3)
 elif sys.platform=="linux":
  try:
   out["memory"]={k:int(v.strip().split()[0]) for k,v in (line.split(":",1) for line in pathlib.Path("/proc/meminfo").read_text().splitlines()) if k in ("MemTotal","MemAvailable","SwapFree")}
  except (OSError,ValueError):pass
 if shutil.which("nvidia-smi"):
  out["nvidia"]=command(["nvidia-smi","--query-gpu=utilization.gpu,memory.used,power.draw,temperature.gpu","--format=csv,noheader,nounits"],4)
 return out
def samples_in(path):
 try:
  with open(path,newline="") as f:
   rows=list(csv.DictReader(f))
  keys=("latency_ns","elapsed_ns","duration_ns","gpu_ns")
  for key in keys:
   if rows and key in rows[0]:return [int(r[key]) for r in rows if r[key]]
 except (OSError,ValueError,KeyError):pass
 return []
def execute(name,cmd,session,timeout,warmups,samples):
 before={p.resolve() for p in (ROOT/"results"/"raw").glob("*.csv")}
 start=time.monotonic_ns()
 start_unix=time.time_ns()
 try:
  p=subprocess.run(cmd,cwd=ROOT,text=True,capture_output=True,timeout=timeout)
  status="ok" if p.returncode==0 else "failed";reason=p.stderr[-1500:] if p.returncode else ""
 except (OSError,subprocess.TimeoutExpired) as exc:
  status="failed";reason=str(exc);p=None
 end_unix=time.time_ns()
 wall_ms=(time.monotonic_ns()-start)/1e6
 after={p.resolve() for p in (ROOT/"results"/"raw").glob("*.csv")}
 raw=sorted(after-before,key=lambda p:p.stat().st_mtime_ns)
 timings=[n for f in raw for n in samples_in(f)]
 energy=telemetry.integrate_power(POWER_SAMPLES,start_unix,end_unix) if POWER_SAMPLES else None
 return {"name":name,"status":status,"reason":reason,"wall_ms":wall_ms,"warmups_requested":warmups,"samples_requested":samples,"samples_observed":len(timings),"median_ns":statistics.median(timings) if timings else None,"p95_ns":sorted(timings)[min(len(timings)-1,int(.95*(len(timings)-1)))] if timings else None,"raw_csv":[str(f.relative_to(ROOT)) for f in raw],"stdout_tail":p.stdout[-1000:] if p else "","energy_joules":energy,"energy_status":"measured external whole-process window" if energy is not None else "unavailable: no aligned calibrated external power samples"}
def main():
 a=argparse.ArgumentParser()
 for k,default in [("elements",65536),("warmups",10),("samples",30),("timeout",600)]:a.add_argument("--"+k,type=int,default=default)
 a.add_argument("--power-csv",default=None,help="External calibrated sensor: unix_ns,power_watts,source")
 v=a.parse_args()
 global POWER_SAMPLES
 POWER_SAMPLES=telemetry.read_power_csv(v.power_csv)
 if not (1<=v.elements<=16777216 and 0<=v.warmups<=10000 and 1<=v.samples<=10000 and 1<=v.timeout<=86400):a.error("Out-of-range parameter")
 session=ROOT/"results"/"sessions"/(datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ")+"-"+uuid.uuid4().hex[:8])
 session.mkdir(parents=True)
 (ROOT/"results"/"raw").mkdir(parents=True,exist_ok=True)
 (session/"environment.json").write_text(json.dumps(environment(),indent=2))
 (session/"telemetry_capabilities.json").write_text(json.dumps(telemetry.capabilities(),indent=2))
 stop=threading.Event()
 def monitor():
  with (session/"resources.jsonl").open("a") as f:
   while not stop.is_set():
    f.write(json.dumps(telemetry.sample())+"\n");f.flush();stop.wait(2)
 worker=threading.Thread(target=monitor,daemon=True);worker.start()
 cases=[
  ("precision",["cargo","run","--release","-p","pco-precision","--",str(v.elements),str(v.samples)],"cargo"),
  ("metal",["bash","scripts/gpu/run-metal-primitives.sh",str(v.elements),str(v.samples),"17"],"bash"),
  ("wgpu",["cargo","run","--release","-p","pco-wgpu","--",str(v.elements),str(v.warmups),str(v.samples)],"cargo"),
  ("accelerate",["bash","scripts/research/run-accelerate.sh",str(v.elements),str(v.warmups),str(v.samples)],"bash"),
  ("mlx",[sys.executable,"scripts/research/mlx-benchmark.py",str(v.elements),str(v.warmups),str(v.samples)],"python")]
 records=[]
 try:
  with (session/"runs.jsonl").open("w") as f:
   for name,cmd,required in cases:
    if not shutil.which(required):r={"name":name,"status":"skipped","reason":"Missing executable: "+required,"energy_joules":None}
    elif name in ("metal","accelerate","mlx") and sys.platform!="darwin":r={"name":name,"status":"skipped","reason":"Requires macOS","energy_joules":None}
    else:r=execute(name,cmd,session,v.timeout,v.warmups,v.samples)
    records.append(r);f.write(json.dumps(r)+"\n");f.flush();print(name,r["status"],flush=True)
 finally:stop.set();worker.join(timeout=5)
 (session/"resource_summary.json").write_text(json.dumps(telemetry.summarize_resource_file(session/"resources.jsonl"),indent=2))
 fields=["name","status","reason","wall_ms","warmups_requested","samples_requested","samples_observed","median_ns","p95_ns","energy_joules","energy_status"]
 with (session/"summary.csv").open("w",newline="") as f:
  w=csv.DictWriter(f,fieldnames=fields,extrasaction="ignore");w.writeheader();w.writerows(records)
 body="".join("<tr>"+"".join("<td>"+html.escape(str(r.get(k,"—")))+"</td>" for k in fields)+"</tr>" for r in records)
 report="<!doctype html><html><meta charset='utf-8'><title>Compute report</title><style>body{font:14px system-ui;margin:3rem}table{border-collapse:collapse}td,th{border:1px solid #aaa;padding:8px}th{background:#eee}</style><h1>Compute interaction report</h1><p>Different backend timing scopes are NOT comparable as GPU speedups. Missing energy is unavailable, not zero. Raw CSV files, host environment, capability inventory, resource summary and timestamped resource samples accompany this report. External energy, if present, is whole-process energy and includes non-kernel overhead.</p><table><tr>"+"".join("<th>"+html.escape(k)+"</th>" for k in fields)+"</tr>"+body+"</table></html>"
 (session/"report.html").write_text(report)
 print("REPORT:"+str(session/"report.html"))
if __name__=="__main__":main()
