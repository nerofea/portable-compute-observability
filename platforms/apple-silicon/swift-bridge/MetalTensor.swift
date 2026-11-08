import Foundation
import Metal
let args=CommandLine.arguments
let n=args.count>1 ? (Int(args[1]) ?? 64) : 64
let warmups=args.count>2 ? (Int(args[2]) ?? 10) : 10
let samples=args.count>3 ? (Int(args[3]) ?? 30) : 30
precondition(n>0 && n<=512 && warmups>=0 && warmups<=10000 && samples>0 && samples<=10000)
guard let device=MTLCreateSystemDefaultDevice(),let queue=device.makeCommandQueue() else {fatalError("Metal unavailable")}
let source=try String(contentsOfFile:"platforms/apple-silicon/metal-shaders/tensor.metal",encoding:.utf8)
let library=try device.makeLibrary(source:source,options:nil)
let kernels=["gemm_f32":"pco_gemm_f32","gemm_f16":"pco_gemm_f16","dot_f32":"pco_dot_partial"]
var pipelines:[String:MTLComputePipelineState]=[:]
for (key,name) in kernels {pipelines[key]=try device.makeComputePipelineState(function:library.makeFunction(name:name)!)}
let count=n*n
let valuesA=(0..<count).map{Float($0%13-6)/17}
let valuesB=(0..<count).map{Float($0%11-5)/13}
let a32=device.makeBuffer(bytes:valuesA,length:count*4,options:.storageModeShared)!
let b32=device.makeBuffer(bytes:valuesB,length:count*4,options:.storageModeShared)!
let ah=valuesA.map{Float16($0)}
let bh=valuesB.map{Float16($0)}
let a16=device.makeBuffer(bytes:ah,length:count*2,options:.storageModeShared)!
let b16=device.makeBuffer(bytes:bh,length:count*2,options:.storageModeShared)!
let output=device.makeBuffer(length:count*4,options:.storageModeShared)!
let ptr=output.contents().bindMemory(to:Float.self,capacity:count)
func execute(_ op:String)->(UInt64,Double?) {
 let pipe=pipelines[op]!
 let cb=queue.makeCommandBuffer()!
 let enc=cb.makeComputeCommandEncoder()!
 enc.setComputePipelineState(pipe)
 enc.setBuffer(op=="gemm_f16" ? a16:a32,offset:0,index:0)
 enc.setBuffer(op=="gemm_f16" ? b16:b32,offset:0,index:1)
 enc.setBuffer(output,offset:0,index:2)
 var side=UInt32(op=="dot_f32" ? count:n)
 enc.setBytes(&side,length:4,index:3)
 if op=="dot_f32" {
  let w=min(256,pipe.maxTotalThreadsPerThreadgroup)
  enc.dispatchThreads(MTLSize(width:count,height:1,depth:1),threadsPerThreadgroup:MTLSize(width:w,height:1,depth:1))
 } else {
  let w=min(8,pipe.maxTotalThreadsPerThreadgroup)
  enc.dispatchThreads(MTLSize(width:n,height:n,depth:1),threadsPerThreadgroup:MTLSize(width:w,height:w,depth:1))
 }
 enc.endEncoding()
 let start=DispatchTime.now().uptimeNanoseconds
 cb.commit();cb.waitUntilCompleted()
 let elapsed=DispatchTime.now().uptimeNanoseconds-start
 guard cb.status == .completed else {fatalError("GPU command failed")}
 let gpu=cb.gpuEndTime>cb.gpuStartTime ? (cb.gpuEndTime-cb.gpuStartTime)*1e9:nil
 return (elapsed,gpu)
}
try FileManager.default.createDirectory(atPath:"results/raw",withIntermediateDirectories:true)
let path="results/raw/metal-tensor-\(Int(Date().timeIntervalSince1970*1e9)).csv"
var csv="backend,workload,format,arithmetic,accumulation,elements,iteration,dispatch_completion_ns,gpu_command_ns,rmse_vs_f32,max_abs_error,validation\n"
for op in ["gemm_f32","gemm_f16","dot_f32"] {
 for _ in 0..<warmups {_=execute(op)}
 var errors=[Double]()
 if op=="dot_f32" {
  let expected=zip(valuesA,valuesB).map{Double($0)*Double($1)}
  let actual=(0..<count).reduce(0.0){$0+Double(ptr[$1])}
  errors=[abs(actual-expected.reduce(0,+))]
 } else {
  for i in 0..<n {for j in 0..<n {
   var expected=0.0
   for k in 0..<n {expected+=Double(valuesA[i*n+k])*Double(valuesB[k*n+j])}
   errors.append(abs(Double(ptr[i*n+j])-expected))
  }}
 }
 let maxError=errors.max() ?? 0
 let rmse=sqrt(errors.reduce(0){$0+$1*$1}/Double(errors.count))
 let tolerance=op=="gemm_f16" ? 0.05:0.005
 guard maxError<tolerance else {fatalError("Validation failed: \(op), max error \(maxError)")}
 for iteration in 0..<samples {
  let (wall,gpu)=execute(op)
  csv+="metal,\(op),\(op=="gemm_f16" ? "fp16":"fp32"),native_gpu,\(op=="gemm_f16" ? "fp32":"fp32"),\(count),\(iteration),\(wall),\(gpu.map{String(format:"%.0f",$0)} ?? ""),\(rmse),\(maxError),pass\n"
 }
}
try csv.write(toFile:path,atomically:true,encoding:.utf8)
print("Saved \(path)")
