#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/engines/cuda/deferred-count"
cargo build --workspace
if [[ "${1:-}" == "--cuda" ]]; then
  bash "$ROOT/scripts/check-cuda.sh"
  cmake -S cpp/cccl-shim -B build/cuda -DCMAKE_BUILD_TYPE=Release
  cmake --build build/cuda --parallel
fi
