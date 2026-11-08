#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == Darwin ]] || { echo 'macOS required' >&2; exit 2; }
mkdir -p results/local results/raw
xcrun swiftc -O platforms/apple-silicon/swift-bridge/AccelerateVector.swift -o results/local/accelerate-vector
results/local/accelerate-vector "${1:-65536}" "${2:-10}" "${3:-30}"
