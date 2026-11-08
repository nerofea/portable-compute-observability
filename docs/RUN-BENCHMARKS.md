# Benchmark suite — copy/paste terminal commands

**Status:** CPU vector-add/copy/scale/triad and standalone Metal vector-add have source implementations; neither is confirmed to run on Apple M5. The AI, ZK, collection and hardware catalogues are *plans*, not executable suites. Read [implementation audit](IMPLEMENTATION-TRACKS.md).

## 1. Checkout and prerequisites
macOS: Xcode Command Line Tools or Xcode with Swift/Metal compiler, Rust toolchain. Linux: Rust toolchain. NVIDIA: installed compatible driver and `nvidia-smi`. Some commands need administrator permissions.

```bash
git clone -b feat/apple-m5-benchmark-suite https://github.com/nerofea/portable-compute-observability.git
cd portable-compute-observability
cargo --version
rustc --version
bash scripts/benchmark-environment.sh
```

For an existing checkout:
```bash
git fetch origin
git switch feat/apple-m5-benchmark-suite
git pull --ff-only
```

## 2. Smoke test (CPU, all supported operating systems)
```bash
cargo test --workspace
cargo run --release -p pco-runner -- run --suite apple-m5-smoke
```

## 3. CPU and memory baseline
```bash
cargo run --release -p pco-runner -- run --suite apple-m5-baseline
```

## 4. Apple M5 Metal GPU (macOS only)
```bash
zsh scripts/run-m5-metal.sh 1048576 30
```
Uses standalone Swift/Metal. GPU timing availability varies. Metal and CPU currently use different timing boundaries; **do not interpret their results as a fair speedup**.

## 5. All currently runnable benchmarks
```bash
bash scripts/benchmark-all.sh apple-m5-baseline
```
This does **not** execute the planned AI, ZK, collection, CUDA or wgpu catalogues.

## 6. Electricity / power / thermal telemetry (separate terminal)
Run one sampler in terminal A, then the benchmark in terminal B. Capture enough duration to cover the benchmark. Sampling and benchmark are not yet synchronized.

Apple Silicon terminal A:
```bash
bash scripts/telemetry/apple-powermetrics.sh 1000 120
```
If sampler names are unsupported, inspect `sudo powermetrics --help` and edit the sampler list. Sudo is required.

NVIDIA Linux terminal A:
```bash
bash scripts/telemetry/nvidia-power.sh 500 120
```

Linux Intel RAPL terminal A:
```bash
bash scripts/telemetry/linux-rapl.sh 120
```

Terminal B (while sampler is running):
```bash
bash scripts/benchmark-all.sh apple-m5-baseline
```

**Important:** macOS powermetrics reports estimated component power, NVIDIA reports GPU/device power, and RAPL reports energy counters. None establishes whole-machine PSU or wall-socket watts. An external meter or supported PSU interface is required for wall input measurements. No automatic joule integration, per-kernel energy attribution, or PSU adapter exists yet.

## 7. Compiler / profiling environment
```bash
bash scripts/inspect-compiler.sh
```
On macOS with Xcode, see available Instruments templates (manual tracing still required):
```bash
xcrun xctrace list templates
```
On NVIDIA Linux, verify CUDA tools if installed:
```bash
command -v nvcc && nvcc --version
command -v ncu && ncu --version
command -v nsys && nsys --version
```
These commands discover capabilities; CUDA, Nsight and Instruments benchmark adapters are not implemented.

## 8. Outputs
- `results/raw/`: benchmark CSV and telemetry captures (gitignored).
- `results/local/`: hardware inventory and local binaries (gitignored).
- `experiments/apple-m5/`: **executable** Rust manifests.
- `experiments/catalog/`: **planned**, non-executable workload inventories.

Do not publish hardware inventory without checking for serial numbers, hostnames or identifiers. No measured results should be claimed until the commands run and outputs are validated.

## 9. Failures
- Missing Rust: install via rustup, then check `rustc --version`.
- Metal unavailable: confirm Xcode, `xcrun --find swiftc`, `xcrun --find metal`.
- powermetrics errors: check sampler support and permissions with `sudo powermetrics --help`.
- Missing NVIDIA telemetry: `nvidia-smi` must be visible to the environment; WSL device access varies.
- Unsupported experiment: the Rust runner accepts only implemented CPU workloads, not the catalogues.
