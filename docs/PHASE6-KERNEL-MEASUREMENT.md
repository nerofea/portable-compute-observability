# Phase 6: Kernel timing and native counter probe

Run:
```bash
bash scripts/gpu/run-metal-kernel-counters.sh 65536 10 30
xcrun swift platforms/apple-silicon/swift-bridge/MetalCounterProbe.swift
```

The Metal runner creates GPU command time and dispatch-to-completion time, validates the output, and probes timestamp counters at dispatch boundaries. **Raw counter timestamps are not converted to nanoseconds**, and kernel-specific time remains unavailable until GPU/CPU timestamp calibration is validated. This avoids false kernel timing claims. Metal counter-set inventory identifies which statistics are actually available on the host.

The thermal monitor compiles a native Swift ProcessInfo.thermalState helper and polls it during the session. Thermal pressure is not temperature in degrees. Apple powermetrics CPU/GPU component power samples remain receipt-timestamped estimates; they cannot be integrated into kernel joules without timestamp synchronization and sufficiently long stable workload windows.

External calibrated whole-process energy integration remains supported by --power-csv. Do not treat whole-process joules as kernel-only joules. No per-kernel energy attribution is claimed.

Limitations: Apple M5 compilation and hardware counter support must be verified on the actual machine. True hardware kernel joules require synchronized power sensors with sufficient sampling rate or a controlled repeated-kernel power experiment with idle subtraction, error bounds, and attribution limitations.
