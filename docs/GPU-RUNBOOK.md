# GPU benchmark runbook — Apple Metal / NVIDIA tooling

This file is a **copy/paste command index**. The standalone native Metal kernels are source implementations; successful execution on the user's M5 is not yet verified. wgpu/CUDA GPU compute backends, Metal counters, unified-memory comparisons, power attribution, and AI/ZK kernels remain missing.

## Checkout
```bash
git fetch origin
git switch feat/apple-m5-benchmark-suite
git pull --ff-only
```

## Discover GPU and compiler environment
```bash
bash scripts/gpu/discover.sh
bash scripts/inspect-compiler.sh
```

## Native Metal primitive benchmarks (macOS)
```bash
bash scripts/gpu/run-metal-primitives.sh 1048576 30 17
```
Runs vector add, scale, triad and strided gather, validates every element, and writes dispatch-to-completion and optional Metal GPU command timestamps. GPU time may be unavailable on a given device. Shared buffers are used; no shared-versus-private experiment yet.

## Original Metal vector add
```bash
zsh scripts/run-m5-metal.sh 1048576 30
```

## Apple power sampling (terminal A)
```bash
bash scripts/telemetry/apple-powermetrics.sh 1000 120
```
Run the Metal benchmark in terminal B. Raw sensor readings are not synchronized to workload boundaries, and are not wall/PSU measurements. `powermetrics` sampler availability varies.

## NVIDIA tools
```bash
bash scripts/gpu/discover.sh
bash scripts/telemetry/nvidia-power.sh 500 120
bash scripts/gpu/profile-nvidia.sh ./your-existing-cuda-benchmark
```
The final command requires an actual executable. This repository does not yet contain CUDA compute kernels.

## Metal profiling
```bash
bash scripts/gpu/profile-metal.sh
```
Displays templates and a suggested Instruments command; does not silently assume Metal System Trace is installed.

## Remaining GPU engineering
1. Shared Rust GPU workload/validation interface and Metal backend integration.
2. wgpu/WGSL backend with portable feature/capability checks.
3. CUDA kernels and Nsight counters, including kernel launch and occupancy.
4. GPU buffer lifecycle: shared/private, allocation, transfers, CPU/GPU synchronization, concurrent queues.
5. Kernel suite: reduction, scan, GEMM, transpose, sort, sparse, attention, cryptographic field/NTT/MSM.
6. Hardware-counter/roofline, energy alignment, sustained thermal runs, confidence intervals and autotuning.
7. Automated reports, cross-backend comparable timing, and performance regression gates.
