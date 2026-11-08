"""Best-effort macOS powermetrics collection; component estimates are not wall power."""
import csv, pathlib, re, shutil, subprocess, sys, threading, time
PATTERN = re.compile(r'^\s*(CPU Power|GPU Power|ANE Power|Combined Power)\s*:\s*([0-9]+(?:\.[0-9]+)?)\s*(mW|W)\s*$', re.I)
def parse_power_line(line):
 m=PATTERN.match(line)
 if not m:return None
 label,number,unit=m.groups()
 return label.lower().replace(' ','_')+'_watts',float(number)/(1000 if unit.lower()=='mw' else 1)
def supported():return sys.platform=='darwin' and bool(shutil.which('powermetrics'))
class ApplePowerSampler:
 def __init__(self,destination,interval_ms=1000):
  self.path=pathlib.Path(destination);self.interval_ms=interval_ms;self.proc=None;self.thread=None;self.status='not_started';self.samples=0
 def start(self):
  if not supported():
   self.status='unavailable: powermetrics not installed or not macOS';return
  cmd=['sudo','-n','powermetrics','--samplers','cpu_power,gpu_power','-i',str(self.interval_ms)] if shutil.which('sudo') else ['powermetrics','--samplers','cpu_power,gpu_power','-i',str(self.interval_ms)]
  try:self.proc=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,bufsize=1)
  except OSError as exc:self.status='unavailable: '+str(exc);return
  self.status='collecting';self.thread=threading.Thread(target=self._read,daemon=True);self.thread.start()
 def _read(self):
  with self.path.open('w',newline='') as out:
   writer=csv.writer(out);writer.writerow(['unix_ns_received','component','power_watts','source','timestamp_quality'])
   for line in self.proc.stdout:
    result=parse_power_line(line)
    if result:
     component,watts=result;writer.writerow([time.time_ns(),component,watts,'apple_powermetrics','receipt_time_only']);out.flush();self.samples+=1
  code=self.proc.wait()
  self.status='stopped' if self.samples else f'unavailable: no power records; exit={code} (check permissions and supported samplers)'
 def stop(self):
  if self.proc and self.proc.poll() is None:
   self.proc.terminate()
   try:self.proc.wait(timeout=4)
   except subprocess.TimeoutExpired:self.proc.kill();self.proc.wait()
  if self.thread:self.thread.join(timeout=5)
  return {'status':self.status,'samples':self.samples,'path':str(self.path)}
