"""Controlled power windows: sensor provenance, baseline correction, uncertainty."""
import csv,math,statistics
def read_component_csv(path):
 try:
  with open(path,newline="") as f:
   return [(int(r["unix_ns_received"]),r["component"],float(r["power_watts"])) for r in csv.DictReader(f) if r.get("unix_ns_received")]
 except (OSError,ValueError,KeyError):return []
def read_external_csv(path):
 if not path:return []
 with open(path,newline="") as f:
  return [(int(r["unix_ns"]),float(r["power_watts"])) for r in csv.DictReader(f)]
def estimate(samples,baseline,active,source,max_gap_s=5):
 """Return incremental joules with trapezoid integration; require full interval coverage."""
 if len(samples)<2:return {"status":"unavailable: fewer than two power samples","source":source}
 samples=sorted(samples)
 if any(not math.isfinite(p) or p<0 for _,p in samples):return {"status":"unavailable: invalid power values","source":source}
 def integral(start,end):
  if start>=end or start<samples[0][0] or end>samples[-1][0]:return None
  points=[]
  for i,((t,p),(u,q)) in enumerate(zip(samples,samples[1:])):
   if u<=start or t>=end:continue
   lo=max(start,t);hi=min(end,u)
   if hi<=lo:continue
   if (u-t)>max_gap_s*1e9:return None
   pl=p+(q-p)*(lo-t)/(u-t);ph=p+(q-p)*(hi-t)/(u-t)
   points.append((lo,hi,(pl+ph)*(hi-lo)*.5e-9))
  if not points or points[0][0]!=start or points[-1][1]!=end:return None
  if any(points[i][1]!=points[i+1][0] for i in range(len(points)-1)):return None
  return sum(p[2] for p in points)
 idle=integral(*baseline);work=integral(*active)
 if idle is None or work is None:return {"status":"unavailable: sensor did not continuously cover baseline and workload","source":source}
 baseline_w=idle/((baseline[1]-baseline[0])*1e-9)
 net=work-baseline_w*((active[1]-active[0])*1e-9)
 return {"status":"estimated_incremental","source":source,"baseline_watts":baseline_w,"active_joules":work,"net_joules":net,"active_seconds":(active[1]-active[0])*1e-9,
 "warning":"Net may be negative due to noise. Baseline-adjusted component or system estimate, not kernel-exclusive energy."}
def repeat_statistics(records):
 values=[r["net_joules"] for r in records if r.get("status")=="estimated_incremental"]
 if len(values)<3:return {"n":len(values),"median_net_joules":statistics.median(values) if values else None,"uncertainty":"unavailable: need >=3 measured repeats"}
 mean=statistics.mean(values);sd=statistics.stdev(values)
 return {"n":len(values),"mean_net_joules":mean,"median_net_joules":statistics.median(values),"sample_sd_joules":sd,"approx_95_ci_mean_joules":[mean-1.96*sd/math.sqrt(len(values)),mean+1.96*sd/math.sqrt(len(values))],"uncertainty":"normal approximation; not valid as strict confidence interval for small n or autocorrelated samples"}
