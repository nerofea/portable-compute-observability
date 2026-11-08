#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == "Darwin" ]] || { echo "macOS required" >&2; exit 2; }
mkdir -p results/local results/raw
xcrun swiftc -O platforms/apple-silicon/swift-bridge/MetalTensor.swift -o results/local/metal-tensor
results/local/metal-tensor "${1:-64}" "${2:-10}" "${3:-30}"
