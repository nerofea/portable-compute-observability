#!/usr/bin/env python3
"""MLX GPU computational workloads. Per-operation failure is reported, never silently counted as pass."""
import csv,pathlib,sys,time
import mlx.core as mx
n=int(sys.argv[1]) if len(sys.argv)>1 else 64
warmups=int(sys.argv[2]) if len(sys.argv)>2 else 30
samples=int(sys.argv[3]) if len(sys.argv)>3 else 100
if not(8<=n<=256 and 0<=warmups<=10000 and 1<=samples<=10000):raise ValueError("invalid MLX workload parameters")
mx.set_default_device(mx.gpu)
a=mx.ones((n,n),dtype=mx.float32)*0.03125
b=mx.ones((n,n),dtype=mx.float32)*0.0625
batch=mx.ones((4,n,n),dtype=mx.float32)*0.125
tensor6=mx.ones((2,2,2,2,2,n),dtype=mx.float32)
kernel=mx.ones((8,3,3,3),dtype=mx.float32)*0.01
image=mx.ones((1,32,32,3),dtype=mx.float32)*0.125
def fft():return mx.fft.fft(a.astype(mx.complex64))
def ifft():return mx.fft.ifft(mx.fft.fft(a.astype(mx.complex64)))
def gemm():return mx.matmul(a,b)
def batched_gemm():return mx.matmul(batch,batch)
def attention():
 scores=mx.matmul(a,mx.transpose(b))*(n**-0.5)
 return mx.matmul(mx.softmax(scores,axis=-1),a)
def convolution():return mx.conv2d(image,kernel)
def tensor_add_6d():return tensor6+tensor6
def dot():return mx.sum(a[0]*b[0])
def grad_dense():
 def loss(w):return mx.sum(mx.square(mx.matmul(a,w)-b))
 return mx.grad(loss)(a)
operations={"fft_complex64":fft,"ifft_complex64":ifft,"gemm_f32":gemm,"batched_gemm_f32":batched_gemm,
 "attention_f32":attention,"conv2d_f32":convolution,"tensor_add_6d":tensor_add_6d,
 "dot_f32":dot,"dense_backward_f32":grad_dense}
out=pathlib.Path("results/raw");out.mkdir(parents=True,exist_ok=True)
path=out/f"mlx-compute-{time.time_ns()}.csv"
failures=[]
with path.open("w",newline="") as f:
 writer=csv.writer(f)
 writer.writerow(["backend","workload","format","elements","iteration","elapsed_ns","validation","validation_level","timing_scope"])
 for name,fn in operations.items():
  try:
   for _ in range(warmups):mx.eval(fn())
   for i in range(samples):
    start=time.perf_counter_ns();result=fn();mx.eval(result);elapsed=time.perf_counter_ns()-start
    valid=bool(mx.all(mx.isfinite(result)).item())
    if not valid:raise RuntimeError("non-finite output")
    writer.writerow(["mlx",name,"complex64" if "complex64" in name else "fp32",int(result.size),i,elapsed,"pass","finite_only","dispatch_eval_wall"])
   print("PASS",name,flush=True)
  except Exception as exc:
   failures.append(name)
   print("UNSUPPORTED_OR_FAILED",name,type(exc).__name__,str(exc)[:300],file=sys.stderr,flush=True)
print("Saved",path)
if failures:
 print("Failed operations: "+", ".join(failures),file=sys.stderr)
 sys.exit(1)
