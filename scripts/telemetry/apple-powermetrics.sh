#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == Darwin ]] || { echo "macOS only" >&2; exit 2; }
command -v powermetrics >/dev/null || { echo "powermetrics unavailable" >&2; exit 2; }
interval_ms="${1:-1000}"
duration_s="${2:-60}"
[[ "$interval_ms" =~ ^[0-9]+$ && "$duration_s" =~ ^[0-9]+$ ]] || exit 2
(( interval_ms >= 100 && duration_s >= 1 && duration_s <= 3600 )) || { echo "Invalid interval/duration" >&2; exit 2; }
mkdir -p results/raw
out="results/raw/apple-power-$(date -u +%Y%m%dT%H%M%SZ).txt"
echo "Sampling powermetrics for ${duration_s}s at ${interval_ms}ms; requires sudo."
# Raw output: sampler names and available rails vary by macOS/chip.
sudo powermetrics --samplers cpu_power,gpu_power,thermal -i "$interval_ms" -n "$((duration_s*1000/interval_ms))" > "$out"
echo "$out"
