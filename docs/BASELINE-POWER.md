# Baseline-first repeated benchmarking on Apple M5

## One command (from the repository root)
```bash
git fetch origin && git switch feat/apple-m5-benchmark-suite && git pull --ff-only && bash scripts/run-all.sh --warmups 30 --samples 100 --repeats 3 --idle-seconds 3 --baseline-seconds 6
```

The controller launches the Apple power sampler **before** the first baseline interval and keeps it running during the entire experiment. Each backend repeat has a 3-second quiet settling interval followed by a **6-second measured idle baseline**, then the active process window. It records the exact Unix-nanosecond baseline and active boundaries. After a run it waits for a subsequent sensor reading before estimating energy. Sensor timestamps from Apple powermetrics are receipt timestamps, not hardware-synchronized sampling timestamps.

Each of the 10 configured backends is attempted 3 times, so up to 30 independent process attempts. The new default is 30 warmups and 100 measurements per operation for backends honoring CLI controls. The Rust CPU manifest still uses its own warmup/sample counts. Do not assume 30 warmups is sufficient for thermal steady state: examine repeated-run drift and thermal logs.

**Power access:** On Apple Silicon, `powermetrics` may require administrator privileges. The suite does **not** invoke sudo automatically. You can check `sudo powermetrics --samplers cpu_power,gpu_power -i 1000 -n 3` separately; sampler names vary by macOS version. A successful privileged check does not authorize the benchmark subprocess. For true continuous wall-power measurements, supply a calibrated externally collected `unix_ns,power_watts,source` CSV using `--power-csv /absolute/path.csv`, with samples bracketing every baseline and active window. A static CSV recorded before the run cannot contain future power samples; arrange for the external meter to write the trace **while** the benchmark runs and ensure the collector sees the data.

## Results
- `energy_windows.csv`: each backend repeat, component or external meter, idle watts, gross active joules, incremental joules, status.
- `energy_uncertainty.json`: repeat-level mean/median/SD and an approximate 95% CI when at least 3 valid repeats exist.
- `apple_power_components.csv`: raw receipt-timestamped Apple component-power estimates.
- `thermal.jsonl`, `resources.jsonl`: thermal pressure and CPU/RAM/GPU observations.
- `kernel_metrics.csv`, `repeat_summary.csv`, `report.html`, `report.md`, `report.txt`, `report.json`, `raw/`: timing, provenance and diagnostic artifacts.

**Interpretation:** Baseline-adjusted *process-window* joules include compilation, initialization and transfers. They are **not** kernel-exclusive energy or calibrated wall-socket energy when sourced from powermetrics. Negative net joules are preserved (noise/drift), not clamped to zero. Missing sensor coverage produces `unavailable`, not zero. CI is a normal approximation and may be poor for three repeats.

## Computational coverage added
`mlx-compute.py` adds MLX GPU FFT/IFFT, GEMM, batched GEMM, attention, convolution, six-dimensional elementwise arithmetic, dot reduction and automatic differentiation. It uses finite-output validation only, not an independent numerical oracle. Unsupported MLX APIs fail visibly rather than producing fabricated results.

**Not implemented:** Native Metal 4 TensorOps/MPP, GPU SHA-256/Keccak, Merkle, finite-field NTT/MSM, real ZK rollup prover and verifier, native FP8/FP4/BF16 hardware execution, detailed Metal cache/occupancy counters, calibrated per-kernel joules. These cannot be certified without implementing the algorithms and testing the specific M5 hardware. This commit does not claim they are complete.
