import Foundation
import Metal

// Standalone GPU primitive benchmark. Source must run from repository root.
// Timing boundaries: dispatch-to-completion wall time and Metal command GPU time (if available).
// Does not measure power, allocation or CPU<->GPU transfer costs.
enum Workload: String, CaseIterable { case vectorAdd = "vector_add", scale, triad, gather }
let args = CommandLine.arguments
let count = args.count > 1 ? (Int(args[1]) ?? 1048576) : 1048576
let trials = args.count > 2 ? (Int(args[2]) ?? 30) : 30
let stride = args.count > 3 ? (Int(args[3]) ?? 17) : 17
let warmups = args.count > 4 ? (Int(args[4]) ?? 30) : 30
precondition(count > 0 && count <= 16777216 && trials > 0 && trials <= 100000 && stride > 0 && warmups >= 0 && warmups <= 10000)
guard let device = MTLCreateSystemDefaultDevice(), let queue = device.makeCommandQueue() else {
    fatalError("Metal device or queue unavailable")
}
let source = try String(contentsOfFile: "platforms/apple-silicon/metal-shaders/primitives.metal", encoding: .utf8)
let library = try device.makeLibrary(source: source, options: nil)
let names = ["vector_add":"pco_vector_add", "scale":"pco_scale", "triad":"pco_triad", "gather":"pco_strided_gather"]
var pipelines: [String: MTLComputePipelineState] = [:]
for (workload, function) in names {
    pipelines[workload] = try device.makeComputePipelineState(function: library.makeFunction(name: function)!)
}
let bytes = count * MemoryLayout<Float>.stride
guard let a = device.makeBuffer(length: bytes, options: .storageModeShared),
      let b = device.makeBuffer(length: bytes, options: .storageModeShared),
      let out = device.makeBuffer(length: bytes, options: .storageModeShared) else {
    fatalError("Shared buffer allocation failed")
}
let ap = a.contents().bindMemory(to: Float.self, capacity: count)
let bp = b.contents().bindMemory(to: Float.self, capacity: count)
let op = out.contents().bindMemory(to: Float.self, capacity: count)
for i in 0..<count {
    ap[i] = Float(i % 997) * 0.001
    bp[i] = Float(i % 991) * 0.002
}
func execute(_ workload: String) -> (UInt64, Double) {
    let pipeline = pipelines[workload]!
    guard let command = queue.makeCommandBuffer(),
          let encoder = command.makeComputeCommandEncoder() else {
        fatalError("Metal command creation failed")
    }
    encoder.setComputePipelineState(pipeline)
    encoder.setBuffer(a, offset: 0, index: 0)
    var n = UInt32(count)
    var factor: Float = 2.0
    var s = UInt32(stride)
    if workload == "vector_add" || workload == "triad" {
        encoder.setBuffer(b, offset: 0, index: 1)
        encoder.setBuffer(out, offset: 0, index: 2)
        if workload == "triad" { encoder.setBytes(&factor, length: 4, index: 3); encoder.setBytes(&n, length: 4, index: 4) }
        else { encoder.setBytes(&n, length: 4, index: 3) }
    } else {
        encoder.setBuffer(out, offset: 0, index: 1)
        if workload == "scale" { encoder.setBytes(&factor, length: 4, index: 2) }
        else { encoder.setBytes(&s, length: 4, index: 2) }
        encoder.setBytes(&n, length: 4, index: 3)
    }
    let width = min(256, pipeline.maxTotalThreadsPerThreadgroup)
    encoder.dispatchThreads(MTLSize(width: count, height: 1, depth: 1),
                            threadsPerThreadgroup: MTLSize(width: width, height: 1, depth: 1))
    encoder.endEncoding()
    let start = DispatchTime.now().uptimeNanoseconds
    command.commit()
    command.waitUntilCompleted()
    let elapsed = DispatchTime.now().uptimeNanoseconds - start
    guard command.status == .completed else { fatalError("GPU command failed: \(String(describing: command.error))") }
    let gpuNS = command.gpuEndTime > command.gpuStartTime && command.gpuStartTime > 0
        ? (command.gpuEndTime - command.gpuStartTime) * 1e9 : Double.nan
    return (elapsed, gpuNS)
}
func expected(_ workload: String, _ i: Int) -> Float {
    switch workload {
    case "vector_add": return ap[i] + bp[i]
    case "scale": return ap[i] * 2
    case "triad": return ap[i] + 2 * bp[i]
    case "gather": return ap[(i * stride) % count]
    default: fatalError("Unknown workload")
    }
}
try FileManager.default.createDirectory(atPath: "results/raw", withIntermediateDirectories: true)
let outputPath = "results/raw/metal-primitives-\(count)-\(Int(Date().timeIntervalSince1970)).csv"
var csv = "workload,backend,elements,iteration,dispatch_completion_ns,gpu_command_ns,logical_bytes,validation\n"
for workload in ["vector_add", "scale", "triad", "gather"] {
    for _ in 0..<warmups { _ = execute(workload) }
    for i in 0..<count {
        let actual = op[i], want = expected(workload, i)
        precondition(abs(actual - want) <= 1e-5 + abs(want) * 1e-5, "Mismatch \(workload) at \(i)")
    }
    let logicalBytes = count * (workload == "vector_add" || workload == "triad" ? 12 : 8)
    for trial in 0..<trials {
        let (wall, gpu) = execute(workload)
        csv += "\(workload),metal,\(count),\(trial),\(wall),\(gpu.isNaN ? "" : String(format: "%.0f",gpu)),\(logicalBytes),pass\n"
    }
}
try csv.write(toFile: outputPath, atomically: true, encoding: .utf8)
print("Device: \(device.name), SIMD width: \(pipelines["vector_add"]!.threadExecutionWidth), max threads/threadgroup: \(pipelines["vector_add"]!.maxTotalThreadsPerThreadgroup)")
print("Saved \(outputPath)")
