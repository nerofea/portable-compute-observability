import Foundation
let state = ProcessInfo.processInfo.thermalState
let label: String
switch state {
case .nominal: label = "nominal"
case .fair: label = "fair"
case .serious: label = "serious"
case .critical: label = "critical"
@unknown default: label = "unknown"
}
print(label)
