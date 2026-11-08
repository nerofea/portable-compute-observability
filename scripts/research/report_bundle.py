"""Reproducible session reports with explicit timing scopes and unavailable measurements."""
import csv,html,json,pathlib,shutil,statistics
METRICS=("latency_ns","elapsed_ns","duration_ns","dispatch_completion_ns","gpu_command_ns","gpu_ns","kernel_counter_ns")
def percentile(values,p):
 if not values:return None
 s=sorted(values);return s[round((len(s)-1)*p)]
def summarize_csv(path,backend):
 with open(path,newline="") as f:reader=csv.DictReader(f);rows=list(reader);columns=reader.fieldnames or []
 if not rows:return []
 scope=next((c for c in METRICS if c in columns and any(r.get(c) for r in rows)),None)
 if scope is None:return []
 groups={}
 for row in rows:
  workload=row.get("workload","unspecified")
  if row.get("validation","pass").lower() not in ("pass","ok","true",""):
   continue
  try:value=float(row[scope])
  except (ValueError,TypeError,KeyError):continue
  if value<0:continue
  key=(workload,row.get("elements",""),scope)
  groups.setdefault(key,[]).append(value)
 return [dict(backend=backend,workload=k[0],elements=k[1],timing_scope=k[2],samples=len(v),
              median_ns=statistics.median(v),p95_ns=percentile(v,.95),p99_ns=percentile(v,.99),
              min_ns=min(v),max_ns=max(v),source_csv=str(path.name))
         for k,v in sorted(groups.items())]
def bundle(session,root,records):
 session=pathlib.Path(session);root=pathlib.Path(root)
 raw_dir=session/"raw";raw_dir.mkdir(exist_ok=True)
 metrics=[]
 for r in records:
  copied=[]
  for relative in r.get("raw_csv",[]):
   path=root/relative
   if not path.is_file():continue
   destination=raw_dir/path.name
   shutil.copy2(path,destination)
   copied.append(str(destination.relative_to(session)))
   try:metrics.extend(summarize_csv(destination,r["name"]))
   except (OSError,UnicodeError,csv.Error,ValueError) as e:r.setdefault("report_warnings",[]).append(str(e))
  r["session_raw_csv"]=copied
 with (session/"kernel_metrics.csv").open("w",newline="") as f:
  fields=["backend","workload","elements","timing_scope","samples","median_ns","p95_ns","p99_ns","min_ns","max_ns","source_csv"]
  writer=csv.DictWriter(f,fieldnames=fields);writer.writeheader();writer.writerows(metrics)
 with (session/"summary.csv").open("w",newline="") as f:
  fields=["name","status","reason","wall_ms","warmups_requested","samples_requested","samples_observed","median_ns","p95_ns","energy_joules","energy_status"]
  writer=csv.DictWriter(f,fieldnames=fields,extrasaction="ignore");writer.writeheader();writer.writerows(records)
 status_counts={s:sum(r.get("status")==s for r in records) for s in ("ok","failed","skipped")}
 lines=["# Portable Compute Observability — Benchmark Report","",
  f"Session: `{session.name}`","",
  f"**Completed:** {status_counts['ok']} | **Failed:** {status_counts['failed']} | **Skipped:** {status_counts['skipped']}","",
  "## Backend execution","",
  "| Backend | Status | Wall time (ms) | Samples | Notes |",
  "|---|---|---:|---:|---|"]
 for r in records:
  note=str(r.get("reason","")).replace("|","/").replace("\n"," ")[:180]
  lines.append(f"| {r.get('name')} | {r.get('status')} | {r.get('wall_ms','—')} | {r.get('samples_observed','—')} | {note} |")
 lines+=["","## Kernel metrics (nanoseconds)","",
         "These are **not cross-backend speedups**: each backend may measure a different scope.",
         "","| Backend | Workload | Elements | Timing scope | N | Median ns | p95 ns | p99 ns |",
         "|---|---|---:|---|---:|---:|---:|---:|"]
 for m in metrics:
  lines.append(f"| {m['backend']} | {m['workload']} | {m['elements']} | {m['timing_scope']} | {m['samples']} | {m['median_ns']:.0f} | {m['p95_ns']:.0f} | {m['p99_ns']:.0f} |")
 lines+=["","## Electricity, GPU, CPU and RAM telemetry","",
         "See `resources.jsonl`, `resource_summary.json`, `apple_power_components.csv` (when available), `thermal.jsonl` (when available), and `telemetry_capabilities.json`.",
         "Missing or unauthorized sensors are **unavailable**, not zero. External calibrated power CSV, when supplied, gives whole-process joules including overhead, **not kernel-only joules**.",
         "Apple powermetrics values are estimated component power and receipt-time stamped; they are not integrated into kernel-specific energy.",
         "","## Reproduction and artifacts","",
         "See `environment.json` for hardware, compiler and Git revision; `runs.jsonl` for backend diagnostics; `raw/` for archived CSV samples.",
         "No backend speedup or energy-efficiency ranking is claimed without matched timing scopes and calibrated attribution."]
 markdown="\n".join(lines)+"\n"
 (session/"report.md").write_text(markdown,encoding="utf-8")
 (session/"report.txt").write_text(markdown.replace("**","").replace("`",""),encoding="utf-8")
 page="<!doctype html><html><meta charset='utf-8'><title>Compute Benchmark Report</title><style>body{font:15px system-ui;margin:3rem;max-width:1300px}table{border-collapse:collapse;width:100%;margin:1em 0}td,th{border:1px solid #bbb;padding:8px;text-align:left}th{background:#eee}code{background:#eee;padding:2px}</style><h1>Portable Compute Observability — Benchmark Report</h1>"
 page+=f"<p>Session: <code>{html.escape(session.name)}</code> | Completed {status_counts['ok']}, Failed {status_counts['failed']}, Skipped {status_counts['skipped']}</p>"
 for heading,items,fields in [("Backend execution",records,["name","status","wall_ms","samples_observed","reason","energy_joules","energy_status"]),("Kernel metrics",metrics,["backend","workload","elements","timing_scope","samples","median_ns","p95_ns","p99_ns"])]:
  page+="<h2>"+heading+"</h2><table><tr>"+"".join("<th>"+html.escape(k)+"</th>" for k in fields)+"</tr>"
  for item in items:page+="<tr>"+"".join("<td>"+html.escape(str(item.get(k,"—")))+"</td>" for k in fields)+"</tr>"
  page+="</table>"
 page+="<h2>Measurement limitations</h2><p>Timing scopes differ across backends. No cross-backend speedup ranking. External power is whole-process energy; Apple component estimates are not kernel joules. Missing counters are unavailable, not zero.</p><p>See report.md, report.txt, summary.csv, kernel_metrics.csv, raw/, resources.jsonl, environment.json and telemetry_capabilities.json in this session directory.</p></html>"
 (session/"report.html").write_text(page,encoding="utf-8")
 (session/"report.json").write_text(json.dumps({"session":session.name,"status_counts":status_counts,"backends":records,"kernel_metrics":metrics},indent=2),encoding="utf-8")
 return status_counts,metrics
