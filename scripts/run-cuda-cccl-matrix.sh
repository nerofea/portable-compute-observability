#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-inventory}"
case "$MODE" in
  inventory)
    bash "$ROOT/scripts/check-cuda-cccl-matrix.sh"
    ;;
  smoke)
    bash "$ROOT/scripts/check-cuda-cccl-matrix.sh"
    bash "$ROOT/scripts/run-deferred-count.sh" smoke
    ;;
  gpu)
    echo "GPU version-matrix execution is not implemented yet: the CUDA shim is a placeholder." >&2
    echo "Implement and verify real CUDA kernels, deferred CUB calls and event timing before publishing measurements." >&2
    exit 3
    ;;
  *)
    echo "Usage: bash scripts/run-cuda-cccl-matrix.sh {inventory|smoke|gpu}" >&2
    exit 2
    ;;
esac
