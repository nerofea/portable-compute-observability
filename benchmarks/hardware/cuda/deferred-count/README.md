# Deferred-count CUDA benchmark

All code and data contracts live in this repository. No rust-ai dependency.

Run from repository root:

```bash
bash scripts/run-deferred-count.sh smoke
bash scripts/run-deferred-count.sh deferred
bash scripts/run-deferred-count.sh full
```

Only CPU smoke validation is implemented in this initial scaffold. GPU modes intentionally fail until real CUDA kernels, CUB deferred-size calls and GPU timing are implemented. See docs/deferred-count for research requirements.
