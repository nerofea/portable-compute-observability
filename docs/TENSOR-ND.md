# Multidimensional tensor compute (initial implementation)

`pco-tensor` adds row-major tensors with checked shape and indexing for ranks **1–8**, including 5D and 6D. The benchmark covers ranks 1–6 by default, bounded to 262,144 elements to avoid explosive allocations.

Implemented CPU reference operations: elementwise add, elementwise multiply, vector dot (f64 accumulation), 2D matrix multiply (f32 accumulation), and square batched matrix multiply for ranks 3–6. Shapes and validation are checked; unit tests cover 6D/8D indexing, 2D GEMM and batched GEMM.

Numerical representation experiments: FP32, software BF16, software FP16, symmetric INT8 and experimental block FP8, with RMSE/max absolute error versus an FP32-input reference. **All execution arithmetic uses f32 on CPU** (dot accumulates f64); these results are not native FP16/BF16/INT8/FP8 accelerator throughput. Do not compare format timing as native dtype performance.

Run `cargo test -p pco-tensor` and `cargo run --release -p pco-tensor -- 8 10 30`. The existing `bash scripts/run-all.sh` now includes this backend. CSV is archived into each session and included in reports.

Still missing: native GPU GEMM and tensor cores/Metal 4 TensorOps, multidimensional broadcasting and strided tensor views, true native reduced precision, FFT, neural-network forward/backward and cryptographic proof workloads. Hardware compilation has not been verified.
