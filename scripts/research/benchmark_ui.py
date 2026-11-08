#!/usr/bin/env python3
"""Local-only one-click benchmark dashboard. No external HTTP dependencies."""
import http.server, json, pathlib, subprocess, sys, threading
ROOT=pathlib.Path(__file__).resolve().parents[2]
STATE={"running":False,"status":"Ready","report":None}
LOCK=threading.Lock()
HTML="""<!doctype html><html><meta charset="utf-8"><title>Compute Laboratory</title><style>body{background:#0c1526;color:#e9f0ff;font:16px system-ui;max-width:760px;margin:8vh auto;padding:24px}section{background:#15243a;padding:24px;border-radius:12px}input{padding:9px;background:#18253a;color:white;border:1px solid #53627a;width:110px}label{display:inline-grid;gap:8px;margin:10px}button{background:#56b6fc;border:0;border-radius:8px;padding:14px 30px;cursor:pointer}a{color:#82caff}pre{white-space:pre-wrap}</style><h1>Compute Interaction Laboratory</h1><section><label>Elements<input id="elements" type="number" value="65536" min="1" max="16777216"></label><label>Warmups<input id="warmups" type="number" value="10" min="0" max="10000"></label><label>Samples<input id="samples" type="number" value="30" min="1" max="10000"></label><label>Timeout seconds<input id="timeout" type="number" value="600" min="1" max="86400"></label><p><button id="start">Start benchmarks</button></p><pre id="status">Ready</pre><p id="report"></p></section><script>async function refresh(){const r=await(await fetch('/status')).json();document.querySelector('#status').textContent=r.status;document.querySelector('#start').disabled=r.running;document.querySelector('#report').innerHTML=r.report?'<a href="/report">Open HTML report</a>':''}document.querySelector('#start').onclick=async()=>{const v={};for(const k of ['elements','warmups','samples','timeout'])v[k]=Number(document.getElementById(k).value);const r=await fetch('/start',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(v)});if(!r.ok)alert(await r.text());refresh()};setInterval(refresh,2000);refresh()</script></html>"""
class Handler(http.server.BaseHTTPRequestHandler):
 def respond(self,status,body,kind="application/json"):
  self.send_response(status);self.send_header("Content-Type",kind);self.send_header("Cache-Control","no-store");self.send_header("Content-Length",str(len(body)));self.end_headers();self.wfile.write(body)
 def do_GET(self):
  if self.path=="/":return self.respond(200,HTML.encode(),"text/html")
  if self.path=="/status":
   with LOCK: state=dict(STATE)
   return self.respond(200,json.dumps(state).encode())
  if self.path=="/report":
   with LOCK: path=STATE["report"]
   if path and pathlib.Path(path).is_file():return self.respond(200,pathlib.Path(path).read_bytes(),"text/html")
  self.respond(404,b"Not found","text/plain")
 def do_POST(self):
  if self.path!="/start":return self.respond(404,b"Not found","text/plain")
  try:
   n=int(self.headers.get("Content-Length","0"))
   if n<1 or n>4096:raise ValueError("Invalid request size")
   args=json.loads(self.rfile.read(n))
   for k,lo,hi in [("elements",1,16777216),("warmups",0,10000),("samples",1,10000),("timeout",1,86400)]:
    if type(args.get(k)) is not int or not lo<=args[k]<=hi:raise ValueError("Invalid "+k)
  except (ValueError,TypeError) as exc:return self.respond(400,str(exc).encode(),"text/plain")
  with LOCK:
   if STATE["running"]:return self.respond(409,b"Already running","text/plain")
   STATE.update(running=True,status="Running...",report=None)
  def job():
   cmd=[sys.executable,"scripts/research/benchmark_control.py"]
   for k in ("elements","warmups","samples","timeout"):cmd.extend(["--"+k,str(args[k])])
   try:
    p=subprocess.run(cmd,cwd=ROOT,capture_output=True,text=True,timeout=args["timeout"]*5+120)
    report=next((line.split("REPORT:",1)[1].strip() for line in p.stdout.splitlines() if line.startswith("REPORT:")),None)
    with LOCK:STATE.update(running=False,status="Exit "+str(p.returncode)+"\n"+p.stdout[-2500:]+"\n"+p.stderr[-1000:],report=report)
   except Exception as exc:
    with LOCK:STATE.update(running=False,status=str(exc),report=None)
  threading.Thread(target=job,daemon=True).start()
  self.respond(202,b'{"started":true}')
if __name__=="__main__":
 print("Open http://127.0.0.1:8765/");http.server.ThreadingHTTPServer(("127.0.0.1",8765),Handler).serve_forever()
