# Phase 3: local benchmark control and resource telemetry

Launch on Apple Silicon:

```bash
git switch feat/apple-m5-benchmark-suite
git pull --ff-only
python3 scripts/research/benchmark_ui.py
```

Open http://127.0.0.1:8765 and click Start. CLI: `python3 scripts/research/benchmark_control.py --elements 65536 --warmups 10 --samples 30 --timeout 600`.

Runs are bounded and sequential. Sessions produce `results/sessions/<id>/environment.json`, `resources.jsonl`, `runs.jsonl`, `summary.csv` and `report.html`. Raw kernel CSV is preserved under `results/raw`.

**Measurement contract:** subprocess wall duration and raw kernel timings have different boundaries. Metal command completion, wgpu dispatch/readback, MLX synchronization, CPU arithmetic and Accelerate timings must not be ranked as equivalent until transfer, compilation and synchronization scopes match. Missing GPU power/energy is null, not zero. Resource monitoring is system-level best effort, not per-process attribution. The UI binds only to loopback; it does not require root. Per-backend subprocess timeouts and bounded iteration counts apply.

Backends: existing precision and Metal runners; Rust/wgpu, Swift Accelerate and Python MLX adapters are separate integration tracks. MPP TensorOps, Core ML/ANE, calibrated energy, GPU timestamp parity, compiler artifacts and native reduced-precision GEMM are not yet included. All code requires verification on an M5 before performance claims.
