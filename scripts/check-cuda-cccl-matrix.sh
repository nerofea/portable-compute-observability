#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:-$ROOT/results/deferred-count/toolchain-inventory.tsv}"
mkdir -p "$(dirname "$OUT")"
printf 'configuration\tnvcc\tcuda_release\tcccl_version\tdeferred_symbol\tstatus\n' > "$OUT"
record() {
  local id="$1" cuda_home="$2" cccl_root="$3"
  local nvcc="$cuda_home/bin/nvcc" release="unknown" version="unknown" symbol="no" status="missing-toolkit"
  if [[ -x "$nvcc" ]]; then
    release="$("$nvcc" --version | sed -n 's/.*release \([0-9.]*\),.*/\1/p' | tail -1)"
    status="headers-not-found"
    local header=""
    for candidate in "$cccl_root/cub/version.cuh" "$cccl_root/targets/x86_64-linux/include/cub/version.cuh" "$cccl_root/include/cub/version.cuh"; do
      if [[ -f "$candidate" ]]; then header="$candidate"; break; fi
    done
    if [[ -n "$header" ]]; then
      version="$(sed -n 's/^#define CUB_VERSION \([0-9][0-9]*\).*/\1/p' "$header" | head -1)"
      [[ -n "$version" ]] || version="unknown"
      status="header-found-not-compile-tested"
      if grep -R -l -F 'args::deferred' "$cccl_root/cub" "$cccl_root/libcudacxx" "$cccl_root/cuda" 2>/dev/null | head -1 | grep -q .; then symbol="yes"; fi
    fi
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$nvcc" "$release" "$version" "$symbol" "$status" | tee -a "$OUT"
}
record "cuda129-bundled" "${CUDA_12_9_HOME:-/usr/local/cuda-12.9}" "${CUDA_12_9_HOME:-/usr/local/cuda-12.9}"
if [[ -d "${CCCL_35_ROOT:-/mnt/c/dev/gpu/dependencies/cccl-3.5}" ]]; then
  record "cuda129-cccl35" "${CUDA_12_9_HOME:-/usr/local/cuda-12.9}" "${CCCL_35_ROOT:-/mnt/c/dev/gpu/dependencies/cccl-3.5}"
else
  printf 'cuda129-cccl35\t-\t-\t-\t-\tcccl-checkout-missing\n' | tee -a "$OUT"
fi
if [[ -n "${CUDA_NEW_HOME:-}" ]]; then
  record "cuda-new-cccl35" "$CUDA_NEW_HOME" "${CCCL_35_ROOT:-/mnt/c/dev/gpu/dependencies/cccl-3.5}"
else
  printf 'cuda-new-cccl35\t-\t-\t-\t-\tnew-toolkit-not-configured\n' | tee -a "$OUT"
fi
echo "Inventory: $OUT"
echo "NOTE: Header inspection is not compilation or GPU execution. No GPU performance result is claimed."
