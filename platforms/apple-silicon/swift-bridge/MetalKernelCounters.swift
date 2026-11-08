import Foundation
import Metal
let argv = CommandLine.arguments
let n = argv.count > 1 ? (Int(argv[1]) ?? 65536) : 65536
let warmups = argv.count > 2 ? (Int(argv[2]) ?? 10) : 10
let trials = argv.count > 3 ? (Int(argv[3]) ?? 30) : 30
precondition(n > 0 && n <= 16_777_216 && warmups >= 0 && warmups <= 10000 && trials > 0 && trials <= 10000)
guard let device = MTLCreateSystemDefaultDevice(), let queue = device.makeCommandQueue() else { fatalError("Metal unavailable") }
let source = try String(contentsOfFile:"platforms/apple-silicon/metal-shaders/primitives.metal",encoding:.utf8)
let library = try device.makeLibrary(source:source,options:nil)
guard let fn = library.makeFunction(name:"pco_vector_add") else { fatalError("Kernel missing") }
let pipeline = try device.makeComputePipelineState(function:fn)
let bytes=n*MemoryLayout<Float>.stride
guard let a=device.makeBuffer(length:bytes,options:.storageModeShared),
 let b=device.makeBuffer(length:bytes,options:.storageModeShared),
 let out=device.makeBuffer(length:bytes,options:.storageModeShared) else { fatalError("Buffer allocation failed") }
let ap=a.contents().bindMemory(to:Float.self,capacity:n)
let bp=b.contents().bindMemory(to:Float.self,capacity:n)
let op=out.contents().bindMemory(to:Float.self,capacity:n)
for i in 0..<n { ap[i]=Float(i%997)*0.001;bp[i]=Float(i%991)*0.002 }
let timestampSet=device.counterSets?.first(where:{$0.name == MTLCommonCounterSet.timestamp.rawValue})
let counterEnabled=timestampSet != nil && device.supportsCounterSampling(.atDispatchBoundary)
func execute()->(UInt64,Double?,Double?) {
 guard let command=queue.makeCommandBuffer() else { fatalError("Command buffer unavailable") }
 var sample: MTLCounterSampleBuffer?
 if counterEnabled,let set=timestampSet {
  let descriptor=MTLCounterSampleBufferDescriptor()
  descriptor.counterSet=set;descriptor.sampleCount=2;descriptor.storageMode = .shared
  sample=try? device.makeCounterSampleBuffer(descriptor:descriptor)
 }
 guard let encoder=command.makeComputeCommandEncoder() else { fatalError("Encoder unavailable") }
 encoder.setComputePipelineState(pipeline)
 encoder.setBuffer(a,offset:0,index:0)
 encoder.setBuffer(b,offset:0,index:1)
 encoder.setBuffer(out,offset:0,index:2)
 var count=UInt32(n);encoder.setBytes(&count,length:4,index:3)
 if let sample=sample { encoder.sampleCounters(sampleBuffer:sample,sampleIndex:0,barrier:true) }
 let width=min(256,pipeline.maxTotalThreadsPerThreadgroup)
 encoder.dispatchThreads(MTLSize(width:n,height:1,depth:1),threadsPerThreadgroup:MTLSize(width:width,height:1,depth:1))
 if let sample=sample { encoder.sampleCounters(sampleBuffer:sample,sampleIndex:1,barrier:true) }
 encoder.endEncoding()
 let begin=DispatchTime.now().uptimeNanoseconds
 command.commit();command.waitUntilCompleted()
 let elapsed=DispatchTime.now().uptimeNanoseconds-begin
 guard command.status == .completed else { fatalError("Metal execution failed: \(String(describing:command.error))") }
 let commandNs=command.gpuEndTime>command.gpuStartTime ? (command.gpuEndTime-command.gpuStartTime)*1e9 : nil
 var counterNs:Double?
 if let sample=sample,let data=try? sample.resolveCounterRange(0..<2),
    data.count >= 2*MemoryLayout<MTLCounterResultTimestamp>.stride {
  let timestamps=data.withUnsafeBytes { ptr -> [UInt64] in
   let p=ptr.bindMemory(to:UInt64.self)
   return [p[0],p[1]]
  }
  if timestamps[0] != 0 && timestamps[1] != 0 && timestamps[0] != UInt64.max &&
     timestamps[1] != UInt64.max && timestamps[1] > timestamps[0] {
   // Raw GPU timestamp ticks: not nanoseconds without clock conversion.
   // The result is deliberately not reported as kernel_ns.
   counterNs=nil
  }
 }
 return (elapsed,commandNs,counterNs)
}
for _ in 0..<warmups { _=execute() }
for i in 0..<n {
 let expected=ap[i]+bp[i]
 precondition(abs(op[i]-expected) <= 1e-5+abs(expected)*1e-5,"Incorrect GPU output")
}
try FileManager.default.createDirectory(atPath:"results/raw",withIntermediateDirectories:true)
let path="results/raw/metal-kernel-counters-\(Int(Date().timeIntervalSince1970*1e9)).csv"
var csv="backend,workload,elements,iteration,dispatch_completion_ns,gpu_command_ns,kernel_counter_ns,validation,counter_status\n"
for trial in 0..<trials {
 let (wall,gpu,kernel)=execute()
 csv+="metal,vector_add,\(n),\(trial),\(wall),\(gpu.map{String(format:"%.0f",$0)} ?? ""),\(kernel.map{String(format:"%.0f",$0)} ?? ""),pass,\(counterEnabled ? "raw_timestamp_not_calibrated" : "unsupported")\n"
}
try csv.write(toFile:path,atomically:true,encoding:.utf8)
print("Saved \(path)")
print("GPU counter timestamp sampling: \(counterEnabled ? "available; conversion pending" : "unsupported")")
