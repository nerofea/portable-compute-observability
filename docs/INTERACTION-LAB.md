# Interaction laboratory: algorithm × compiler × architecture × representation × energy

This is the first **executable factorial experiment orchestrator**, not the completed multi-backend laboratory.

## Run
```bash
git fetch origin
git switch feat/apple-m5-benchmark-suite
git pull --ff-only
bash scripts/research/run-interaction-lab.sh --limit 4
# Complete all 72 cases (2 compiler variants × 4 algorithms × 3 sizes × 3 independent repeats):
bash scripts/research/run-interaction-lab.sh
```
Results are under `results/research/cpu-compiler-algorithm-interaction-v1/`. Re-run to resume completed cases. Raw samples are retained in `results/raw/`. Experiment order is seeded and randomized. The executable is built separately for each RUSTFLAGS variant and hashed; compilation time is excluded from measured process execution.

## What is actually varied
- Algorithm: vector_add/copy/scale/triad.
- Compiler: generic optimized vs target-cpu=native optimized Rust.
- Input size: 1024, 65536, 1048576 f32 elements.
- Repeated independent processes: three per combination.
- Hardware: machine metadata recorded; different machines require independent runs.
- Numerical representation: **currently fixed to f32**; FP16/BF16/BFP/FP8, integer exactness and precision conversions are future backends.
- Energy: optional external power CSV, not automatically captured. Without reliable power measurements the energy field is null.

## External power CSV contract
Optional `--power-csv path.csv` with columns:
```csv
unix_ns,power_watts,source
1760000000000000000,35.2,external-wall-meter
1760000001000000000,38.5,external-wall-meter
```
The timestamp must be Unix nanoseconds, increasing. Power must be nonnegative finite watts. Trapezoidal integration requires samples bracketing **the complete subprocess**. Thus energy refers to process wall time, including startup, not kernel-only time. Samples should be at a sufficiently high rate to capture workload dynamics. Hardware clocks, sensor calibration, idle baseline and source provenance must be assessed before interpreting energy. No measured power is invented. The existing powermetrics/nvidia-smi outputs are not directly compatible with this CSV contract; adapters are still required.

## Outputs and comparability
- `metadata.json`: experiment, OS/arch, toolchain, git commit and sensor provenance.
- `trials.jsonl`: crash-safe append-only trial records, binary hash, raw CSV path, per-case median/p95, bootstrap 95% median CI.
- `summary.csv`: flattened case results.
- `manifest-*.toml`: exact per-case runner inputs.

**Cautions:** A CI calculated by resampling within one process is not a substitute for a CI across independent runs. The orchestrator repeats processes, but does not yet implement hierarchical statistical models, compiler IR diffing, CPU affinity, thermal stabilization, GPU hardware counters or cross-machine comparability gates. Do not interpret process energy as kernel energy.

## Next milestones
1. Add exact numerical-format factor (FP32/BF16/FP16/BFP/FP8) with conversion/error oracles.
2. Add Metal/wgpu/CUDA backend adapters and equivalent timing scopes.
3. Implement aligned power adapters (powermetrics, nvidia-smi, RAPL, external meter) and idle-baseline subtraction.
4. Add compiler artifact capture (LLVM IR, Metal pipeline diagnostics, PTX/SASS where supported).
5. Add hierarchical confidence intervals, regression/comparability gates, thermal/resource budgets and report generation.
