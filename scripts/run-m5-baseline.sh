#!/bin/zsh
set -eu
cargo test --workspace
cargo run --release -p pco-runner -- run --suite apple-m5-baseline
