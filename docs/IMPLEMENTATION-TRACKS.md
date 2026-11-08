# Implementation tracks — updated GPU audit

Source added to this branch: native Metal vector-add, scale, triad and strided-gather kernels with standalone Swift execution and per-element validation; CPU vector-add/copy/scale/triad and memory library; GPU discovery, Metal and NVIDIA profiling launchers, raw power sampler scripts, experiment catalogues and runbooks. All require actual hardware execution and verification.

| Track | Status | Missing |
|---|---|---|
| Native Metal primitives | Source added, unverified | Compile/run on M5, broader kernels, common Rust integration |
| Metal timestamps | Partial | GPU counter calibration, consistent kernel/dispatch/end-to-end boundaries |
| Metal shared buffers | Partial | private/shared comparisons, transfer/sync, memory pressure |
| wgpu/WGSL | Missing | backend, shader suite, timestamp support |
| CUDA kernels | Missing | CUDA backend, kernel parity and profiling |
| GPU equivalence | Partial | Metal per-element checks; unified cross-backend oracle missing |
| CPU and memory | Partial | SIMD/NEON, threads, cache hierarchy, stride and pointer chase runner |
| Arrays and collections | Catalogue only | executable workloads |
| Compiler inspection | Tool discovery | IR/disassembly/shader resource analysis |
| Roofline | Missing | calibrated compute and memory ceilings |
| GPU profiler | Scripts | integrated traces and counter extraction |
| Regression/comparability | Missing | statistical gates and incompatible-run rejection |
| Randomized trials/CI | Missing | seeded order, independent batches and confidence intervals |
| AI/neural networks | Catalogue only | executable MLX/Core ML/ANE/attention/inference |
| Cryptography and ZK | Catalogue only | field/NTT/MSM, commitments, proving, rollups |
| Oloid/SPH simulations | Catalogue only | solver kernels and convergence tests |
| Energy to convergence | Missing | synchronized energy integration and stopping criteria |
| Orchestration | Partial | checkpoint/resume, randomization, backend scheduling |
| Resource limits | Partial | memory/time/power/thermal budgets |
| Reports | Missing | HTML/dashboard and provenance-rich comparisons |
| iOS/visionOS/Windows/ROCm/Vulkan | Planned | target-specific toolchains and runners |

Full commands: [GPU runbook](GPU-RUNBOOK.md) and [general runbook](RUN-BENCHMARKS.md). Full workload list: [coverage](BENCHMARK-COVERAGE.md).
