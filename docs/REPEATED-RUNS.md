# Repeated runs: exact counts and measurement scope

`bash scripts/run-all.sh` defaults to `--repeats 3 --idle-seconds 3 --warmups 10 --samples 30`. This launches **nine backend cases × three independent process runs = 27 attempts**, with three seconds of quiet time before each. Unsupported/missing backends are recorded as skipped.

**Important exceptions (existing backend behavior):**
- Tensor ND: 10 warmups and 30 measured iterations **per operation, precision and shape**. Rank 1–6 (bounded size), FP32/BF16/FP16/INT8/BFP8 CPU software quantization.
- Metal tensor: 10 warmups and 30 measured per operation (FP32 GEMM, FP16 GEMM, partial-product dot).
- Metal kernel counter: 10 warmups and 30 measured for vector add.
- wgpu: 10 warmups and 30 measured for vector add.
- Accelerate: 10 warmups and 30 measured for vector add.
- MLX: 10 warmups and 30 measured for vector add.
- Rust precision: **fixed 10 warmups** and 30 measured **per numerical format**; `--warmups` is not forwarded.
- Metal primitives: **its own warmup behavior**; controller passes 30 measured and seed 17, not `--warmups`. Check raw output for each primitive.
- Rust CPU smoke suite: warmups and measured iterations come from `experiments/apple-m5/smoke.toml`, not the command-line flags.

The runner saves HTML, Markdown, TXT, JSON, CSV and raw files under one session directory. `repeat_summary.csv` reports independent-run outcomes and median process duration; `kernel_metrics.csv` separates workload, precision, shape and timing scope.

**Power:** External calibrated sensor CSV may produce *whole-process* joules when sensor timestamps bracket each run. Apple powermetrics component power is best-effort and not synchronized for kernel-specific joules. `--idle-seconds` is a settling interval, **not idle-power measurement**. No baseline-adjusted joules, joules per kernel or error bars are currently calculated.

`bash scripts/run-all.sh --repeats 5 --idle-seconds 5 --warmups 20 --samples 100` increases repetition for the compatible backends; see exceptions above.

**Missing computational kernels:** FFT/IFFT, GPU convolutions, complete GPU dot reduction, batched Metal GEMM, attention/backprop, GPU SHA/Keccak, Merkle, finite-field, NTT, MSM, and real ZK prover/rollup pipelines. These are **not** part of the current one-command suite.

Do not infer native low-precision GPU arithmetic from software quantization results or compare backend timing scopes without matching them.
