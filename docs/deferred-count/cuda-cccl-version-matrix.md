# CUDA / CCCL version matrix

## Objective
Separate performance changes from CUDA toolkit/compiler upgrades, CCCL library upgrades, and reduction execution policies. All experiments target the same RTX 3070 (SM 8.6), fixed workloads, warmups, and statistical methodology.

## Configurations
See `benchmarks/hardware/cuda/deferred-count/version-matrix.toml`. The CUDA 12.9 bundled baseline is CUB 2.8.2 on the observed machine. CCCL 3.5 and a newer CUDA toolkit are *candidates*, not proven compatible configurations.

## Run
```bash
bash scripts/run-cuda-cccl-matrix.sh inventory
bash scripts/run-cuda-cccl-matrix.sh smoke
# Optional independently checked-out CCCL and side-by-side toolkit:
CCCL_35_ROOT=/path/to/cccl-3.5 CUDA_NEW_HOME=/usr/local/cuda-X.Y bash scripts/run-cuda-cccl-matrix.sh inventory
```

The inventory records installed compiler/header versions and a textual API-symbol probe. It does **not** establish build compatibility. The smoke mode executes existing Rust CPU tests and count validation; it does **not** run CUDA reductions.

## Next engineering gates
1. Verify the exact CCCL 3.5 release/tag and its supported host compiler/CUDA toolkit combinations.
2. Compile a minimal deferred-count CUB probe using explicitly selected CCCL headers and nvcc; avoid mixed CUDA/CCCL header versions.
3. Implement real CUB immediate, readback, deferred and bucketed policies behind the Rust FFI.
4. Validate results and capture CUDA event timings; record compile flags, CUDA driver, clock/thermal state, hardware and full toolchain provenance.
5. Run repeated randomized-order comparisons; publish raw measurements and derived crossover thresholds only after GPU execution.

## Interpretation
Comparing immediate vs deferred under the *same* toolkit and CCCL isolates policy. Comparing old bundled vs newer CUDA/CCCL changes multiple variables; it is a combined stack comparison unless intermediate compatible configurations are tested. Missing or incompatible combinations must be marked unavailable, never silently substituted.
