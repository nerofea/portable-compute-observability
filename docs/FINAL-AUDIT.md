# Final one-command audit (source inspection)

The controller now includes `pco-tensor` (rank 1–6 tensor operations) and `pco-runner` CPU experiments in addition to precision, Metal primitives, Metal tensor GEMM, Metal counter probe, wgpu, Accelerate and MLX.

The report keeps each timing column independently and separates numerical formats and tensor shapes; it no longer mixes FP16 with FP32 or dispatch-completion with GPU-command timing. Each backend is still a different workload/timing contract; do not infer speedups from unpaired rows.

## Still unimplemented

- Native Metal FFT/IFFT, batched FFT, convolutions, attention, full GPU-resident dot reduction, batched GEMM and optimized TensorOps/MPP acceleration.
- Real cryptographic SHA/Keccak/Merkle, finite-field arithmetic, NTT, MSM, prover and rollup execution.
- True hardware BF16/FP8/FP4/INT8 matrix throughput where supported; CPU software quantization is not native arithmetic.
- Per-kernel calibrated joules and idle-corrected energy, per-process CPU/GPU utilization, reliable Metal occupancy/cache/stall counters, sustained thermal regression.
- Hardware verification on the actual Apple M5; local GitHub commits do not prove Swift/Metal builds or kernel validation.

Run from repo root: `bash scripts/run-all.sh`. Review `report.html`, `report.md`, `kernel_metrics.csv`, `runs.jsonl` and per-backend raw CSV. Failed/skipped cases are part of the result, not evidence of successful coverage.
