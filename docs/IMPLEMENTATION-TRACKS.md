# Implementation tracks — source audit

Audit scope: feature branch at commit 39ca7a42, plus this documentation update. Status labels distinguish source present, partial, catalogue-only and absent. **No Apple M5 runtime, CI green status or GPU timing was independently verified.**

| Track | Current status | Remaining deliverable |
|---|---|---|
| Rust runner, deterministic inputs | Partial source | workload registry, stable seed metadata, error handling, CI execution |
| CPU vector-add/copy/scale/triad | Source present | M5 compile/test and measured baseline |
| Arrays/collections | Catalogue only | Vec, maps, trees, sets, queues, sorting/search workloads and runner |
| ARM64 SIMD, threads | Absent | NEON, Rayon, scaling and affinity controls |
| Memory hierarchy | Partial library | pointer chase wired to runner, cache L1/L2/SLC estimates, stride sweeps |
| AoS/SoA, buffer layout | Partial library | layout sweep, alignment, allocations, shared/private GPU buffers |
| Native Metal | Partial standalone source | build verification, more kernels, integrated Rust backend |
| wgpu/WGSL | Absent | portable GPU backend, dispatch/timestamps |
| CUDA / NVIDIA compute | Absent | CUDA kernels and host runner; only NVIDIA telemetry script exists |
| GPU kernel equivalence | Absent | same data and exact/elementwise correctness oracle, comparable timing boundaries |
| Power / thermals | Partial scripts | sampler compatibility, timestamp synchronization, idle baseline, energy integration, external PSU/wall meter |
| Hardware counters / trace | Absent | xctrace/kperf/Metal counter adapters, Perfetto/Chrome traces |
| Roofline | Absent | calibrated peak bandwidth/compute, arithmetic intensity and charts |
| Compiler inspection | Partial script | disassembly/LLVM IR/Metal resource reports and analysis |
| Comparability / regression gates | Absent | reject incompatible runs; statistical significance and baselines |
| Randomized trial order | Absent | seeded interleaving across algorithms/backends |
| Confidence intervals | Absent | independent batches, bootstrap or other CI, variance/MAD |
| AI neural networks | Catalogue only | actual training/inference, attention, quantization, Core ML/MLX/ANE |
| Cryptography / commitments | Catalogue only | hashes, fields, curves, NTT, MSM, Merkle, KZG, IPA, correctness vectors |
| ZK proving / rollups | Catalogue only | prover adapters, witness/prove/verify, recursion and aggregation |
| Oloid / SPH / numerical simulation | Catalogue only | force-based simulation kernels, solver validation and convergence |
| Energy to convergence | Absent | aligned energy samples and numerical tolerance/convergence criteria |
| Experiment orchestration | Partial launcher | scheduling, machine state capture, independent batches, backend selection |
| Checkpoint / resume | Absent | durable run state, restart without duplicate samples |
| Resource limits | Partial bounds | per-run RAM/GPU memory/time/temperature budgets and safe cancellation |
| Reports / dashboard | Absent | HTML/JSON/Parquet summaries, plots, comparability warnings |
| macOS CI | Configured, unverified | actual CI run; no self-hosted M5 |
| Linux CI | Configured, unverified | actual CI run and test artifacts |

## Additional missing environments
- iOS/tvOS/visionOS Metal/Core ML device targets and device-side measurement; macOS scripts do not run on iOS.
- Windows PowerShell telemetry and native CUDA/DirectX 12; WSL is not equivalent to native Windows profiling.
- Linux Vulkan, ROCm/AMD, Intel oneAPI/Level Zero, ARM Linux, browser WASM/WebGPU.
- Docker/containers and Kubernetes profiling, virtualization overhead, distributed inference and multi-node compute.
- External wattmeter/PSU hardware adapter, battery discharge tracking and thermal state attribution.
- Reproducible compiler/container environments and version-pinned dependencies for cross-machine comparisons.

## Definition of done
An experiment is complete only when it runs on actual hardware, validates outputs, records timing scope and raw samples, captures environment metadata, reports memory and supported power metrics with provenance, and can be independently repeated. Unsupported metrics must be recorded as unavailable, not zero.
