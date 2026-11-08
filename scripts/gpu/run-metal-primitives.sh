#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == Darwin ]] || { echo "macOS required" >&2; exit 2; }
command -v xcrun >/dev/null || { echo "Xcode command-line tools required" >&2; exit 2; }
mkdir -p results/local results/raw
xcrun swiftc -O platforms/apple-silicon/swift-bridge/MetalPrimitives.swift -o results/local/metal-primitives
results/local/metal-primitives "${1:-1048576}" "${2:-30}" "${3:-17}" "${4:-30}"
