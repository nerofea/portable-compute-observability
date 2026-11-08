#!/usr/bin/env bash
set -euo pipefail
mkdir -p results/local
out="results/local/environment-$(date -u +%Y%m%dT%H%M%SZ).txt"
{
 echo "UTC=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
 uname -a
 command -v rustc >/dev/null && rustc -Vv || true
 command -v cargo >/dev/null && cargo -V || true
 command -v clang >/dev/null && clang --version || true
 if [[ "$(uname -s)" == Darwin ]]; then
  sw_vers
  sysctl -n machdep.cpu.brand_string 2>/dev/null || true
  sysctl -n hw.memsize 2>/dev/null || true
  system_profiler SPHardwareDataType SPDisplaysDataType
  xcrun --find metal 2>/dev/null || true
  xcodebuild -version 2>/dev/null || true
 else
  command -v lscpu >/dev/null && lscpu || true
  command -v free >/dev/null && free -h || true
  command -v nvidia-smi >/dev/null && nvidia-smi -q || true
  command -v nvcc >/dev/null && nvcc --version || true
  command -v rocminfo >/dev/null && rocminfo || true
 fi
} > "$out" 2>&1
printf 'Inventory: %s\nReview for serial numbers and identifiers before sharing.\n' "$out"
