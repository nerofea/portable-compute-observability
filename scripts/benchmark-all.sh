#!/usr/bin/env bash
set -euo pipefail
suite="${1:-apple-m5-smoke}"
mkdir -p results/raw results/local
bash scripts/benchmark-environment.sh
cargo test --workspace
cargo run --release -p pco-runner -- run --suite "$suite"
if [[ "$(uname -s)" == Darwin ]] && command -v xcrun >/dev/null; then
  if xcrun --find swiftc >/dev/null 2>&1; then
    zsh scripts/run-m5-metal.sh "${PCO_GPU_ELEMENTS:-1048576}" "${PCO_GPU_TRIALS:-30}"
  else
    echo "Metal benchmark skipped: Swift compiler unavailable"
  fi
fi
echo "Raw results: results/raw/"
