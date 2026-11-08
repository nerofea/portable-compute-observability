# Full computation benchmark coverage

Status: **catalogue and executable harness expansion**, not proof that every listed workload is implemented. Never treat an unavailable sensor as a zero reading.

| Domain | Required experiments |
|---|---|
| Arrays and collections | Vec/slice/boxed arrays, HashMap/BTreeMap/HashSet/BTreeSet, VecDeque, BinaryHeap, linked lists, sparse CSR/COO, AoS/SoA, strided/tiled/aligned layouts, allocation, iteration, lookup, insert/remove, sort/search |
| CPU | scalar, SIMD/NEON, Rayon, thread pinning where supported, atomics, locks, branch prediction, cache and scheduling |
| GPU | Metal, wgpu/WGSL, CUDA, reductions, scans, sorting, GEMM, transpose, gather/scatter, occupancy, synchronization and transfer |
| Memory | STREAM copy/scale/add/triad, pointer chasing, cache hierarchy, random/strided bandwidth, shared/private buffers, allocation and reuse |
| Numerical | FFT/NTT, convolution, linear algebra, FP16/FP32/FP64 capability, error propagation, convergence |
| AI | MLP, CNN, RNN/LSTM, attention/FlashAttention, transformer prefill/decode, KV cache, optimizers, backpropagation, quantization, MLX, Core ML, llama.cpp |
| Cryptography | SHA2/3, Blake, Poseidon, Rescue, Merkle/MMR, finite fields, Montgomery, elliptic curves, MSM, FFT/NTT, KZG, IPA, FRI |
| ZK | Noir/Barretenberg, Halo2, STARK, zkVM, witness, proving, verifying, recursion, aggregation, rollup batch and state transitions |
| Scientific | SPH, particle simulation, stencil, N-body, solvers and energy-to-convergence |
| Browser | WebGPU, WASM, WebGL, JS, Three.js, buffer movement and shader compilation |
| Energy | Apple powermetrics, Linux powercap/RAPL, NVIDIA nvidia-smi, external wall meter/PSU telemetry when physically connected |
| Runtime | Rust, C/C++, Swift, Python, JS/WASM, compile time, startup, FFI, allocation |
| Storage | mmap, disk I/O, compression, serialization, cold/warm data loading |

## Measurement contract
- Raw samples: monotonic elapsed nanoseconds and milliseconds, timing scope, warmup and repetitions.
- Performance: ops/s, bytes/s, effective GB/s, per-workload latency distributions.
- Memory: logical bytes, peak RSS, buffer allocation and resident size; distinguish measured from inferred.
- Energy: timestamped watts, sampled joules by numerical integration, sample frequency, sensor/rail provenance, idle baseline and uncertainty.
- Power: report CPU/GPU rail estimates separately from system input power and PSU/wall measurements.
- Hardware: chip, CPU/GPU, RAM, OS/kernel, toolchain, driver, clock/power state, thermal conditions.
- Accuracy: exact comparison for cryptographic arithmetic; elementwise tolerance policy for floating-point.
- Comparability: same input, algorithm, precision, timing boundary, validation, and environment; reject incompatible comparisons.
- Provenance: binary hashes, configuration, seed, compiler flags, experiment ID, UTC timestamps.

## Execution priorities
1. Run and validate CPU, RAM, collection and Metal baselines.
2. Integrate portable wgpu and CUDA, and buffer lifecycle benchmarks.
3. Collect calibrated hardware power/thermal traces with timestamps.
4. Implement exact field, NTT, MSM, hash and commitment CPU/GPU kernels.
5. Integrate real AI and ZK prover adapters with end-to-end workloads.
6. Add statistical regression, roofline, reports, dashboards and automated tuning.

## Caveats
Apple powermetrics requires elevated permissions and does not measure AC wall power.
NVIDIA nvidia-smi reports GPU board/device estimates, not total computer PSU draw.
Metal shared/private buffer behavior is hardware-specific; managed storage is not a valid default for Apple Silicon.
No universal GPU support for native 64-bit integer multiplication, 64-bit atomics, or double precision should be assumed.
