import Foundation
import Metal

// Standalone native Metal benchmark. Timing excludes allocation, CPU validation and CSV output.
// Reports command buffer GPU timestamps where available and wall clock dispatch-to-completion.
guard let device = MTLCreateSystemDefaultDevice(), let queue = device.makeCommandQueue() else {
    fatalError("Metal GPU unavailable")
}
let args = CommandLine.arguments
let count = args.count > 1 ? (Int(args[1]) ?? 1048576) : 1048576
let trials = args.count > 2 ? (Int(args[2]) ?? 30) : 30
precondition(count > 0 && count <= 16777216 && trials > 0)
let path = "platforms/apple-silicon/metal-shaders/vector_add.metal"
let source = try String(contentsOfFile: path, encoding: .utf8)
let library = try device.makeLibrary(source: source, options: nil)
let function = library.makeFunction(name: "vector_add")!
let pipeline = try device.makeComputePipelineState(function: function)
let bytes = count * MemoryLayout<Float>.stride
guard let a = device.makeBuffer(length: bytes, options: .storageModeShared),
      let b = device.makeBuffer(length: bytes, options: .storageModeShared),
      let output = device.makeBuffer(length: bytes, options: .storageModeShared) else {
    fatalError("Metal buffer allocation failed")
}
let ap = a.contents().bindMemory(to: Float.self, capacity: count)
let bp = b.contents().bindMemory(to: Float.self, capacity: count)
let op = output.contents().bindMemory(to: Float.self, capacity: count)
for i in 0..<count {
    ap[i] = Float(i % 997) * 0.001
    bp[i] = Float(i % 991) * 0.002
}
func execute() -> (Double,Double) {
    guard let command = queue.makeCommandBuffer(), let encoder = command.makeComputeCommandEncoder() else {
        fatalError("Failed to encode GPU command")
    }
    encoder.setComputePipelineState(pipeline)
    encoder.setBuffer(a, offset: 0, index: 0)
    encoder.setBuffer(b, offset: 0, index: 1)
    encoder.setBuffer(output, offset: 0, index: 2)
    var n = UInt32(count)
    encoder.setBytes(&n, length: MemoryLayout<UInt32>.size, index: 3)
    let width = min(pipeline.maxTotalThreadsPerThreadgroup, 256)
    encoder.dispatchThreads(MTLSize(width: count, height: 1, depth: 1),
                            threadsPerThreadgroup: MTLSize(width: width, height: 1, depth: 1))
    encoder.endEncoding()
    let start = DispatchTime.now().uptimeNanoseconds
    command.commit()
    command.waitUntilCompleted()
    let wall = Double(DispatchTime.now().uptimeNanoseconds - start)
    guard command.status == .completed else { fatalError("GPU command failed: \(String(describing: command.error))") }
    let gpu = (command.gpuEndTime > command.gpuStartTime && command.gpuStartTime > 0)
        ? (command.gpuEndTime - command.gpuStartTime) * 1e9 : Double.nan
    return (wall,gpu)
}
for _ in 0..<10 { _ = execute() }
for i in 0..<count {
    let expected = ap[i] + bp[i]
    precondition(abs(op[i] - expected) <= 1e-5, "GPU output mismatch at index \(i)")
}
try FileManager.default.createDirectory(atPath: "results/raw", withIntermediateDirectories: true)
let outputPath = "results/raw/metal-vector-add-\(count)-\(Int(Date().timeIntervalSince1970)).csv"
var csv = "workload,backend,elements,iteration,dispatch_to_completion_ns,gpu_command_ns,logical_bytes\n"
for i in 0..<trials {
    let (wall,gpu) = execute()
    csv += "vector_add,metal,\(count),\(i),\(Int(wall)),\(gpu.isNaN ? "" : String(format: "%.0f",gpu)),\(count*12)\n"
}
try csv.write(toFile: outputPath, atomically: true, encoding: .utf8)
print("Metal device: \(device.name); saved \(outputPath)")
