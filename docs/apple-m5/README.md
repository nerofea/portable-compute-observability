# Apple M5 benchmark track

## Status
Phase 1: portable Rust CPU reference runner, raw-sample CSV, deterministic input and correctness checks.
Native Metal, wgpu, ANE, power sampling, hardware counters and advanced statistical inference are **planned, not implemented**.

## Run on M5
```sh
cargo test --workspace
cargo run --release -p pco-runner -- run --suite apple-m5-smoke
cargo run --release -p pco-runner -- run --suite apple-m5-baseline
```

Raw CSV output: `results/raw/` (gitignored). Inventory: `zsh scripts/inventory-macos.sh`.
Inspect inventory for private hardware identifiers before publishing.

## Measurement boundaries
CPU timing includes the vector-add loop, excludes input allocation and checksum validation.
Logical bytes = two f32 input streams + one f32 output stream; not a hardware counter.
All samples are retained. Warmups are excluded. No power, GPU, or thermal results are claimed.

## Next implementation tracks
- Native Metal + wgpu GPU kernels and equivalent correctness tests.
- Backend capability matrix: precision, workgroup limits, GPU counters and ANE support.
- Powermetrics and external wattmeter adapters; energy calibration and uncertainty.
- Memory hierarchy, AoS/SoA, stride sweeps, roofline and compiler inspection.
- Regression/comparability gates, randomized trial order, statistical confidence intervals.
- AI attention, vision, cryptography, Oloid simulations and energy-to-convergence.
- Experiment orchestration, checkpoint/resume, resource limits, reports.
