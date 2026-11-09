#!/usr/bin/env bash
set -Eeuo pipefail
command -v cargo >/dev/null || { echo "Missing cargo" >&2; exit 1; }
command -v nvcc >/dev/null || { echo "Missing nvcc / CUDA Toolkit" >&2; exit 1; }
command -v nvidia-smi >/dev/null || { echo "Missing nvidia-smi" >&2; exit 1; }
echo "CUDA compiler:"; nvcc --version | tail -n 4
echo "GPU:"; nvidia-smi --query-gpu=name,compute_cap,driver_version --format=csv,noheader
