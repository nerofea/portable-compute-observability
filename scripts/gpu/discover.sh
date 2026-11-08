#!/usr/bin/env bash
set -euo pipefail
mkdir -p results/local
out="results/local/gpu-discovery-$(date -u +%Y%m%dT%H%M%SZ).txt"
{
  date -u '+UTC=%Y-%m-%dT%H:%M:%SZ'
  uname -a
  if [[ "$(uname -s)" == Darwin ]]; then
    system_profiler SPDisplaysDataType SPHardwareDataType
    xcrun --find metal 2>/dev/null || true
    xcrun --find swiftc 2>/dev/null || true
    xcrun xctrace list templates 2>/dev/null || true
  else
    command -v nvidia-smi >/dev/null && nvidia-smi -q || true
    command -v nvcc >/dev/null && nvcc --version || true
    command -v rocminfo >/dev/null && rocminfo || true
    command -v vulkaninfo >/dev/null && vulkaninfo --summary || true
  fi
} > "$out" 2>&1
echo "$out"
