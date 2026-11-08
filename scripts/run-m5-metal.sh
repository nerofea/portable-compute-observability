#!/bin/zsh
set -eu
mkdir -p results/local
xcrun swiftc -O platforms/apple-silicon/swift-bridge/MetalVectorAdd.swift -o results/local/metal-vector-add
results/local/metal-vector-add "${1:-1048576}" "${2:-30}"
