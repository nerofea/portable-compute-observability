import Foundation
import Metal
guard let device = MTLCreateSystemDefaultDevice() else { fatalError("Metal unavailable") }
let sets = device.counterSets ?? []
let inventory: [[String:Any]] = sets.map { set in
 ["name":set.name,"counters":set.counters.map { $0.name }]
}
let result: [String:Any] = ["device":device.name,"counter_sets":inventory,
 "supports_compute_stage_boundary":device.supportsCounterSampling(.atStageBoundary),
 "supports_dispatch_boundary":device.supportsCounterSampling(.atDispatchBoundary)]
let data = try JSONSerialization.data(withJSONObject:result,options:[.prettyPrinted,.sortedKeys])
print(String(decoding:data,as:UTF8.self))
