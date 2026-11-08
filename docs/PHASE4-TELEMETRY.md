# Phase 4: Native telemetry and energy accounting

The Phase 3 controller now collects timestamped host-resource snapshots via `native_telemetry.py`. On macOS it parses `vm_stat` and `memory_pressure -Q` when available; on Linux it reads `/proc/meminfo` and optionally NVIDIA metrics from `nvidia-smi`. `telemetry_capabilities.json` lists available tools and unavailable counter families. `resource_summary.json` summarizes sampling coverage.

## Run
```bash
python3 scripts/research/test_native_telemetry.py
python3 scripts/research/benchmark_ui.py
# Or with a calibrated external power CSV:
python3 scripts/research/benchmark_control.py --power-csv /path/to/power.csv
```

The power CSV must contain `unix_ns,power_watts,source` with strictly increasing Unix nanosecond timestamps and nonnegative finite watt values. Energy is trapezoidally integrated across each subprocess's wall-clock interval only when both boundaries are bracketed and there are no gaps above five seconds. It is **whole-process energy**, including initialization, compilation and transfers, not isolated kernel energy. It is not automatically baseline corrected. No energy estimate is made without an external calibrated trace.

## Limitations
Apple `powermetrics` is discovered but not automatically run: it can require privileges and may not expose total-system calibrated watts. Metal GPU hardware counters, ANE activity, per-process GPU power, clock frequencies and hardware thermal sensors remain unsupported by this collector. `vm_stat` is system-wide. The collector timestamps use wall and monotonic clocks but are not yet calibrated to hardware GPU clocks. A reliable GPU/CPU energy comparison requires separate matched workload intervals, idle-baseline calibration and verified sensor provenance. Hardware validation on M5 remains outstanding.
