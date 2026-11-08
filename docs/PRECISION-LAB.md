# Numerical representation lab — phase 2

## Copy/paste
```bash
git fetch origin
git switch feat/apple-m5-benchmark-suite
git pull --ff-only
bash scripts/research/run-precision-lab.sh 65536 30
```

The output is `results/raw/precision-<unix>.csv` with per-sample elapsed nanoseconds, RMSE and maximum absolute error against f32 reference. Test vectors include exact FP16 bit patterns.

## What is implemented
- FP32 reference, BF16 round-to-nearest-even conversion, IEEE binary16 software conversion, symmetric INT8 quantization, and a research-only 32-element shared-exponent BFP8 approximation.
- Inputs are quantized **before** the timed loop. Arithmetic is always f32 on CPU. Timed loop measures f32 addition of prequantized values, **not native BF16/FP16/INT8/BFP8 execution throughput**.
- The BFP8 approximation is not an industry-standard packed encoding. FP8 E4M3/E5M2, native tensor cores, mixed-precision accumulation, GPU kernels, and format-specific compiler codegen remain unimplemented.
- Results cannot be compared with GPU Metal timings until equivalent timing boundaries and data layouts are implemented.

## Next research requirements
1. Implement packed representations and native arithmetic capability detection.
2. Add Metal/wgpu/CUDA kernels with exactly matched reference semantics.
3. Factor numerical format into the randomized compiler/algorithm/architecture experiment matrix.
4. Measure conversion cost, transfer cost, quantization error, overflow/underflow, and end-to-end energy.
5. Integrate sensor traces and precision-to-convergence for neural models.
