# Phase 5: Apple power collection and GPU counter discovery

The benchmark controller now attempts to launch `powermetrics --samplers cpu_power,gpu_power -i 1000` without privilege escalation. On systems where it is available and authorized, it records component power estimates to `apple_power_components.csv`, and writes `apple_power_status.json`. Missing permissions or unsupported samplers produce unavailable status, never zero watts. Samples are timestamped at receipt and **are not** calibrated kernel timestamps or wall-socket measurements. They are intentionally **not** integrated into the report's `energy_joules` field.

`platforms/apple-silicon/swift-bridge/ThermalState.swift` exposes macOS thermal pressure as nominal/fair/serious/critical. Run `swift platforms/apple-silicon/swift-bridge/ThermalState.swift`. It is a snapshot utility, not yet a periodic per-experiment thermal sampler.

`bash scripts/gpu/metal-counter-discovery.sh` lists Xcode Instruments templates. Actual Metal GPU hardware counters require supported Instruments capture or a dedicated Metal counter sampling implementation and are **not yet collected**. Some counters may be unavailable on M5.

The controller still supports `--power-csv` for an external calibrated trace, with validated timestamp coverage and gaps. No automatic sudo, no fabricated energy estimates. To test parsing run `python3 scripts/research/test_apple_power.py`.

Pending: calibrated idle-baseline subtraction, per-workload thermal sampling, supported GPU counter capture automation and M5 hardware verification.
