# Apple M5 GPU-native cryptographic compute — implementation plan

Status: **planned, not implemented**. Target repository: `nerofea/portable-compute-observability`. Baseline branch: `feat/apple-m5-benchmark-suite`.

## Goal

Determine which combinations of **Metal, Rust, wgpu, exact finite-field algorithms, GPU memory layouts, dispatch scheduling, and selective CPU/GPU cooperation** yield the best validated throughput, latency, and energy efficiency for ZK workloads. Generic tensor benchmarks do not establish cryptographic performance.

## Architecture

- Rust experiment orchestrator: workload manifests, deterministic vectors, correctness, statistical sampling, telemetry, provenance, JSON/CSV/HTML reports.
- Native Metal backend: Metal Shading Language kernels, compiled shader variants, command buffers, GPU-resident buffers, device timing where supported.
- Rust/wgpu backend: WGSL kernels on macOS Metal backend, explicitly portable integer representations and capability checks.
- CPU reference: independent correctness oracle and small-size crossover baseline, not the primary optimization target.
- Prover adapters: version-pinned reference libraries and independent proof verification. No end-to-end proof claims before valid proofs pass verification.

## Proposed repository additions

```text
crates/
  pco-crypto-core/src/{field,curve,test_vectors}.rs
  pco-gpu-metal/
  pco-gpu-wgpu/
  pco-zk-adapters/
platforms/apple-silicon/metal-shaders/{field,ntt,msm,hashing}.metal
shaders/wgsl/{field,ntt,msm}.wgsl
benchmarks/cryptography/{field_arithmetic,ntt,msm,proving}/
```

Preserve existing `scripts/research/benchmark_control.py` as the initial orchestration entry point; add cases rather than breaking current sessions.

## Implementation sequence

### 01 — `feat/gpu-field-arithmetic`

1. Introduce a canonical field API and deterministic fixtures, including 0, 1, modulus−1, carries, and random values.
2. Start with the Goldilocks prime `p = 2^64 - 2^32 + 1` as an NTT-friendly research field. It is **not** a substitute for BN254/other production fields.
3. Implement add/sub/mul/square/reduction and inversion where needed. Validate against independent Rust big-integer/reference arithmetic.
4. Implement Metal kernels and explicit multiword arithmetic where native integer widths/overflow semantics require it; do not assume a 128-bit shader integer type.
5. Implement WGSL with multiword limbs: portable WGSL lacks native u64 arithmetic.
6. Compare Montgomery versus Barrett or prime-specialized reduction, array-of-structures versus structure-of-arrays, vector widths, and threadgroup sizes.
7. Exit criteria: exact differential tests, repeatable timings and energy measurements, and documented unsupported capabilities.

Suggested commits:
```text
feat(field): add canonical field representation and test vectors
feat(field): implement Metal modular add/sub/mul
feat(field): implement Montgomery reduction
feat(field): implement WGSL multiword arithmetic backend
test(field): add differential and boundary tests
bench(field): record throughput latency and energy
docs(field): document arithmetic and measurement methodology
```

### 02 — `feat/metal-ntt`

- Forward/inverse radix-2 NTT for 2^10 to 2^20 elements, subject to available memory.
- Validate primitive roots, normalization, forward/inverse round trips, and independent reference outputs.
- Compare Cooley–Tukey, Stockham, precomputed twiddles, stage fusion, threadgroup-local butterflies and global-memory passes.
- Measure dispatch count, kernel time, full transform time, memory traffic proxies, transforms/s, and joules/transform.

### 03 — `feat/wgpu-ntt`

- Equivalent math, vectors, sizes and validation in WGSL, using portable multiword representation.
- Compare Metal-native versus wgpu/Metal under equivalent execution scopes; report portability overhead without assuming parity of shader features.

### 04 — `feat/metal-msm`

- Implement Pippenger MSM for a specified real curve (initially BN254), with projective point operations.
- Compare window sizes, bucket accumulation/reduction, point layout, batch normalization, and scheduling.
- Test zero scalar, point at infinity, invalid input handling and independent group-reference outputs.
- Measure MSM/s, points/s, kernel time, end-to-end time, memory and energy.

### 05 — `feat/gpu-kernel-fusion`

- Fuse compatible NTT stages and reuse GPU-resident buffers; compare separate versus batched dispatch and allocation versus pooling.
- Track command-buffer queue/submit/complete timing, synchronization, residency, and end-to-end workload time.
- Overlap independent operations only; respect data dependencies.

### 06 — `feat/gpu-hashing`

- SHA-256, Keccak, Poseidon and Merkle tree workloads with exact reference vectors.
- Compare batching, tree-level scheduling, buffer layouts and GPU/CPU crossover sizes.

### 07 — `feat/gpu-prover-adapters`

- Add version-pinned adapters for representative PLONKish, Groth16 and STARK/FRI/sumcheck workloads, as available.
- Benchmark witness generation, NTT, MSM, polynomial commitments, proof generation and independent verification separately and together.
- Do not claim all rollups use the same proving system or commitment scheme.
- Rollup-specific Aztec, zkSync, Scroll, Polygon zkEVM and Starknet integrations are subsequent separate tracks, each pinned to a specific implementation/version.

### 08 — `feat/gpu-energy-analysis`

- Validate Apple powermetrics collection with explicit privilege/error status; do not silently assume sensor availability.
- Keep CPU/GPU/ANE component power separate from wall/system power.
- Baseline-adjust energy using aligned samples and documented coverage; report uncertainty, including unavailable results.
- Include compiler/build time separately from steady-state execution.

## Benchmark matrix

| Workload | Variants | Input sizes | Primary metrics |
|---|---|---|---|
| Field multiplication | Montgomery, Barrett, prime-specific; layouts | 64-bit research field, then 254/255-bit | ops/s, ns/op, J/op |
| NTT | Cooley–Tukey, Stockham, fused stages | 2^10–2^20 | transforms/s, bandwidth proxy, J/transform |
| MSM | Pippenger windows, layouts, reductions | 2^10–2^18 points | points/s, ms/MSM, J/MSM |
| Memory | reuse versus reallocate | 1–256 MiB | allocation overhead, end-to-end time |
| Scheduling | separate versus batched dispatch | 1–1000 dispatches | submission overhead, queue and GPU time |
| Proving | pinned reference versus GPU-assisted | multiple circuit sizes | valid proofs/s, p50/p95/p99, J/proof |

Default experiment protocol: 30 warmups, 100 samples, 3 independent repeats, 3 seconds idle and 6 seconds baseline when meaningful. For expensive proof runs, use a documented smaller sample count. Record host wall time, dispatch-to-completion time, device time where supported, compilation time separately, input hashes, hardware/software versions, validation and power provenance. Hardware counters marked unsupported must remain unavailable, not synthesized.

## Acceptance gates

1. Field arithmetic: exact reference agreement, adversarial/boundary tests and comparable Metal/WGSL results.
2. NTT: correct forward/inverse transform, roots and output ordering; reported transform size and timings.
3. MSM: exact group result against independent implementation, including edge cases.
4. Fusion: measurable **end-to-end** improvement on identical valid workloads, not just fewer dispatches.
5. Prover: proof accepted by independent verifier; all costs included in end-to-end measurement.

## Initial deliverable

Implement Goldilocks field arithmetic in Rust + Metal + WGSL, then a native Metal NTT. Publish a machine-readable comparison of reduction algorithm, memory layout, dispatch cost, latency/throughput and energy. Treat this document as a development plan, not as evidence these implementations or measurements already exist.
