"""Native macOS thermal-state polling using a compiled Swift helper."""
import pathlib,subprocess,sys,threading,time,json
class ThermalMonitor:
 def __init__(self,path,root,interval=3):
  self.path=pathlib.Path(path);self.root=pathlib.Path(root);self.interval=interval;self.stop_event=threading.Event();self.thread=None;self.status="not_started"
 def start(self):
  if sys.platform!="darwin":self.status="unsupported";return
  binary=self.path.parent/"thermal-probe"
  p=subprocess.run(["xcrun","swiftc","-O",str(self.root/"platforms/apple-silicon/swift-bridge/ThermalState.swift"),"-o",str(binary)],capture_output=True,text=True)
  if p.returncode:self.status="compile_failed: "+p.stderr[-300:];return
  self.status="sampling"
  def run():
   with self.path.open("w") as f:
    while not self.stop_event.is_set():
     try:
      p=subprocess.run([str(binary)],capture_output=True,text=True,timeout=3)
      f.write(json.dumps({"unix_ns":time.time_ns(),"state":p.stdout.strip() if p.returncode==0 else None})+"\n");f.flush()
     except (OSError,subprocess.TimeoutExpired):pass
     self.stop_event.wait(self.interval)
  self.thread=threading.Thread(target=run,daemon=True);self.thread.start()
 def stop(self):
  self.stop_event.set()
  if self.thread:self.thread.join(timeout=5)
  return self.status
