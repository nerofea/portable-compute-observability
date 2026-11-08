#!/usr/bin/env bash
set -euo pipefail
if [[ "$#" -eq 0 ]]; then
  echo "Usage: bash scripts/gpu/profile-nvidia.sh <benchmark-command> [args...]" >&2
  exit 2
fi
mkdir -p results/local
if command -v nsys >/dev/null; then
  nsys profile --force-overwrite=true -o results/local/nsys-profile -- "$@"
elif command -v ncu >/dev/null; then
  ncu --set basic -- "$@"
else
  echo "Nsight Systems (nsys) or Nsight Compute (ncu) not installed" >&2
  exit 2
fi
