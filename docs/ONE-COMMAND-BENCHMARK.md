# One-command benchmark suite

From the repository root, on the Apple M5:

```bash
git fetch origin && git switch feat/apple-m5-benchmark-suite && git pull --ff-only && bash scripts/run-all.sh
```

The runner uses Python 3 standard library. Individual backends need their own dependencies: Rust/Cargo, Xcode command-line tools, MLX Python. Missing dependencies are recorded as SKIPPED, not silently ignored. The suite is **not** an installer. It does not invoke sudo.

Optional controls:
```bash
bash scripts/run-all.sh --elements 1048576 --warmups 20 --samples 100 --timeout 1200
bash scripts/run-all.sh --power-csv /absolute/path/to/calibrated-meter.csv
```

Each run creates a unique `results/sessions/<timestamp-id>/` directory with `report.html`, `report.md`, `report.txt`, `report.json`, `summary.csv`, `kernel_metrics.csv`, `raw/*.csv`, `environment.json`, `telemetry_capabilities.json`, `resources.jsonl`, `resource_summary.json`, `runs.jsonl`, and telemetry traces when supported. Reports open automatically on macOS via `open` when run through the shell entry point.

**Measurement contract:** Raw timing scopes are not interchangeable. Metal GPU command timing is not the same as GPU kernel time. Apple powermetrics is estimated component power, not calibrated wall power. Kernel-specific joules require separate validation. No fabricated values are emitted.

**Audit findings:** The previous controller emitted only HTML/summary CSV, did not archive raw files in each session, did not aggregate GPU CSV fields `dispatch_completion_ns` or `gpu_command_ns`, and could confuse the number of raw samples with workload count. The report bundle addresses the output and archiving gaps. Hardware execution, Metal counter support and calibration remain to be validated on the actual Mac.
