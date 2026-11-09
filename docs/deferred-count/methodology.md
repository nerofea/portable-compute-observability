# Measurement methodology

Target: RTX 3070 (Ampere SM 8.6), CUDA Toolkit 13.5 / CCCL 3.5 compatibility to be verified on target host.

- Compare immediate, host-readback, deferred, bucketed and padded policies.
- Run count traces with matched seeds and balanced randomized policy order.
- Report CPU critical-path time and CUDA-event GPU elapsed time separately; record p50, p95, p99, throughput and bytes processed.
- Warm up before measurements; retain per-sample records, versions, clock/power metadata and git SHA.
- Run policies sequentially on the GPU to avoid contention.
- Separate Nsight profiling runs from production timing runs.
- Use bootstrap confidence intervals for policy differences and crossover estimates.
- Count validation must gate any unsafe reduction, not merely record an error after dispatch.
- Define overflow behavior and arithmetic equivalence for each reduction dtype.
- No placeholder timings may be labeled as GPU measurements.

The initial scaffold implements contracts and CPU validation only; benchmark kernels and reporting are subsequent milestones.
