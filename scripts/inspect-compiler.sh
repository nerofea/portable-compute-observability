#!/usr/bin/env bash
set -euo pipefail
mkdir -p results/local
out="results/local/compiler-inspection-$(date -u +%Y%m%dT%H%M%SZ).txt"
{
 echo "UTC=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
 command -v rustc >/dev/null && rustc -Vv || true
 command -v cargo >/dev/null && cargo -V || true
 command -v clang >/dev/null && clang --version || true
 if [[ "$(uname -s)" == Darwin ]]; then
  xcrun --find metal 2>/dev/null || true
  xcrun --find swiftc 2>/dev/null || true
  xcrun xctrace list templates 2>/dev/null || true
 else
  command -v nvcc >/dev/null && nvcc --version || true
  command -v ncu >/dev/null && ncu --version || true
  command -v nsys >/dev/null && nsys --version || true
 fi
} > "$out" 2>&1
echo "$out"
