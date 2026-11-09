#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-smoke}"
ENGINE="$ROOT/engines/cuda/deferred-count"
case "$MODE" in
  smoke|cpu-test)
    (cd "$ENGINE" && cargo test --workspace && cargo run -p benchmark-runner -- "$MODE")
    ;;
  calibration|immediate|readback|deferred|bucketed|padded|select-reduce|profiling|full)
    bash "$ROOT/scripts/check-cuda.sh"
    (cd "$ENGINE" && cargo run --release -p benchmark-runner -- "$MODE")
    ;;
  *) echo "Unknown deferred-count mode: $MODE" >&2; exit 2 ;;
esac
