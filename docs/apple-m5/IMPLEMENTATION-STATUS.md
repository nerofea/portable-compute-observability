# Apple M5 implementation status (phase 2)

## Implemented source
- Rust manifest-driven CPU vector add, copy, scale, triad; per-element correctness checks; P50/P95/P99 and raw CSV.
- Portable STREAM-style memory kernels (copy, scale, triad), pointer-chase and AoS/SoA data representations; pointer-chase and layouts are library code, not yet wired into the runner.
- Native Metal vector-add kernel and standalone Swift/Metal benchmark, shared Metal buffers, dispatch-to-completion and command-buffer GPU timing where reported.
- Hardware inventory script, reproducibility metadata sidecar and Linux CI configuration.

## Not implemented or not verified
- M5 hardware runs, successful compilation, CI results, macOS-arm64 CI.
- wgpu/WGSL backend, comprehensive Metal kernels, CPU/GPU buffer lifecycle matrix, zero-copy comparisons.
- Power/thermal telemetry, ANE/Core ML/MLX, hardware counters, roofline, confidence intervals and regression detection.
- AI inference, attention, cryptographic primitives, commitments, ZK proving and rollup workloads.
- Hardware inventory integration with per-run measurements; actual experiment scheduling/randomization.

## Commands
```sh
cargo test --workspace
cargo run --release -p pco-runner -- run --suite apple-m5-smoke
cargo run --release -p pco-runner -- run --suite apple-m5-baseline
zsh scripts/run-m5-metal.sh 1048576 30
```

Do not directly compare Rust CPU kernel-only timing with Metal dispatch-to-completion timing; timing boundaries differ. Use equal inputs and explicit timing scopes. Metal's GPU command times are optional and may not be available on all systems.
