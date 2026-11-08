#!/usr/bin/env bash
set -euo pipefail
command -v nvidia-smi >/dev/null || { echo "nvidia-smi not installed" >&2; exit 2; }
interval_ms="${1:-500}"
duration_s="${2:-60}"
[[ "$interval_ms" =~ ^[0-9]+$ && "$duration_s" =~ ^[0-9]+$ ]] || exit 2
(( interval_ms >= 100 && duration_s >= 1 && duration_s <= 3600 )) || exit 2
mkdir -p results/raw
out="results/raw/nvidia-power-$(date -u +%Y%m%dT%H%M%SZ).csv"
echo "timestamp,index,name,power.draw,temperature.gpu,utilization.gpu,utilization.memory,memory.used,clocks.sm,clocks.mem" > "$out"
end=$((SECONDS+duration_s))
while (( SECONDS < end )); do
  nvidia-smi --query-gpu=timestamp,index,name,power.draw,temperature.gpu,utilization.gpu,utilization.memory,memory.used,clocks.sm,clocks.mem --format=csv,noheader,nounits >> "$out"
  sleep "$(awk -v ms="$interval_ms" 'BEGIN{printf "%.3f",ms/1000}')"
done
echo "$out"
