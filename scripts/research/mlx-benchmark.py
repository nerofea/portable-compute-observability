#!/usr/bin/env python3
"""Apple MLX GPU vector-add, synchronized dispatch+evaluation timing."""
import csv,pathlib,sys,time
import mlx.core as mx
n=int(sys.argv[1]) if len(sys.argv)>1 else 65536
warmups=int(sys.argv[2]) if len(sys.argv)>2 else 10
samples=int(sys.argv[3]) if len(sys.argv)>3 else 30
if not (1<=n<=16777216 and 0<=warmups<=10000 and 1<=samples<=10000):raise ValueError("invalid experiment")
mx.set_default_device(mx.gpu)
a=mx.array([float(i%997)*.001 for i in range(n)],dtype=mx.float32)
b=mx.array([float(i%991)*.002 for i in range(n)],dtype=mx.float32)
mx.eval(a,b)
c=a+b;mx.eval(c)
for i,v in enumerate(c[:min(n,1024)].tolist()):
 if abs(v-(float(i%997)*.001+float(i%991)*.002))>1e-5:raise RuntimeError("MLX correctness mismatch")
out=pathlib.Path("results/raw");out.mkdir(parents=True,exist_ok=True)
path=out/f"mlx-{time.time_ns()}.csv"
with path.open("w",newline="") as f:
 w=csv.writer(f);w.writerow(["backend","workload","elements","iteration","elapsed_ns","timing_scope","validation"])
 for i in range(warmups+samples):
  start=time.perf_counter_ns();c=a+b;mx.eval(c);elapsed=time.perf_counter_ns()-start
  if i>=warmups:w.writerow(["mlx","vector_add",n,i-warmups,elapsed,"dispatch_eval_wall","pass"])
print("Saved",path)
