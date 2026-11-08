#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == Linux ]] || exit 2
duration_s="${1:-30}"
[[ "$duration_s" =~ ^[0-9]+$ ]] && ((duration_s>=1 && duration_s<=3600)) || exit 2
mkdir -p results/raw
out="results/raw/rapl-$(date -u +%Y%m%dT%H%M%SZ).csv"
echo "unix_ns,domain,energy_uj" > "$out"
shopt -s nullglob
paths=(/sys/class/powercap/intel-rapl*/energy_uj)
(("${#paths[@]}" > 0)) || { echo "No readable RAPL domains" >&2; exit 2; }
for ((i=0;i<duration_s;i++)); do
  for path in "${paths[@]}"; do
    if [[ -r "$path" ]]; then
      printf '%s,%s,%s\n' "$(date +%s%N)" "$(basename "$(dirname "$path")")" "$(cat "$path")" >> "$out"
    fi
  done
  sleep 1
done
echo "$out"
