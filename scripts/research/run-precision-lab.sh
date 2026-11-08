#!/usr/bin/env bash
set -euo pipefail
cargo test -p pco-precision
cargo run --release -p pco-precision -- "${1:-65536}" "${2:-30}"
