import Foundation
import Accelerate
let args=CommandLine.arguments
let n=args.count>1 ? (Int(args[1]) ?? 65536) : 65536
let warmups=args.count>2 ? (Int(args[2]) ?? 10) : 10
let samples=args.count>3 ? (Int(args[3]) ?? 30) : 30
precondition(n>0 && n<=16_777_216 && warmups>=0 && warmups<=10000 && samples>0 && samples<=10000)
let a=(0..<n).map{Float($0%997)*0.001}
let b=(0..<n).map{Float($0%991)*0.002}
var out=[Float](repeating:0,count:n)
try FileManager.default.createDirectory(atPath:"results/raw",withIntermediateDirectories:true)
let path="results/raw/accelerate-\(Int(Date().timeIntervalSince1970*1e9)).csv"
var csv="backend,workload,elements,iteration,elapsed_ns,timing_scope,validation\n"
for iteration in 0..<(warmups+samples){
 let start=DispatchTime.now().uptimeNanoseconds
 vDSP_vadd(a,1,b,1,&out,1,vDSP_Length(n))
 let elapsed=DispatchTime.now().uptimeNanoseconds-start
 for i in 0..<n {
  let expected=a[i]+b[i]
  precondition(abs(out[i]-expected)<=1e-5+abs(expected)*1e-5)
 }
 if iteration>=warmups{csv+="accelerate,vector_add,\(n),\(iteration-warmups),\(elapsed),library_call_wall,pass\n"}
}
try csv.write(toFile:path,atomically:true,encoding:.utf8)
print("Saved \(path)")
