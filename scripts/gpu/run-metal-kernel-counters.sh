#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == Darwin ]] || { echo "macOS required" >&2; exit 2; }
mkdir -p results/local results/raw
xcrun swiftc -O platforms/apple-silicon/swift-bridge/MetalKernelCounters.swift -o results/local/metal-kernel-counters
results/local/metal-kernel-counters "${1:-65536}" "${2:-10}" "${3:-30}"
