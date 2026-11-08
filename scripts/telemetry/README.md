# Terminal power telemetry

## Apple M5
```bash
bash scripts/telemetry/apple-powermetrics.sh 1000 60
```
Requires administrator approval. Run simultaneously with benchmark in a separate terminal. Available samplers vary; if the command rejects a sampler, inspect `powermetrics --help` and adjust. Reports sensor/rail estimates, **not PSU or wall power**.

## NVIDIA Linux/Windows WSL host
```bash
bash scripts/telemetry/nvidia-power.sh 500 60
```
Requires host-visible `nvidia-smi`. Reports device power, not wall power. Timestamp alignment with workload logs must be calibrated.

## Linux RAPL
```bash
bash scripts/telemetry/linux-rapl.sh 60
```
RAPL energy counters may wrap; readings are energy counter values, not instantaneous watts. Read permissions vary.

## PSU and wall electricity
A USB/serial/network-enabled external power meter, or supported PSU telemetry interface, is required to measure wall/PSU draw. No hardware meter adapter is implemented yet. Avoid interpreting GPU power as whole-system power.
