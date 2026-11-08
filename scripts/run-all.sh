#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
command -v python3 >/dev/null 2>&1 || { echo "ERROR: python3 required" >&2; exit 2; }
echo "== Portable Compute Observability =="
echo "Git: $(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
echo "Platform: $(uname -s) / $(uname -m)"
echo "Running supported backends and archiving session reports..."
LOG="$(mktemp)"
trap 'rm -f "$LOG"' EXIT
python3 scripts/research/benchmark_control.py "$@" 2>&1 | tee "$LOG"
REPORT="$(sed -n 's/^REPORT://p' "$LOG" | tail -n 1)"
if [[ -n "$REPORT" && -f "$REPORT" ]]; then
 echo ""
 echo "Reports saved in: $(dirname "$REPORT")"
 echo "HTML: $REPORT"
 echo "Markdown: $(dirname "$REPORT")/report.md"
 echo "Text: $(dirname "$REPORT")/report.txt"
 echo "CSV: $(dirname "$REPORT")/summary.csv and kernel_metrics.csv"
 if [[ "$(uname -s)" == "Darwin" ]] && command -v open >/dev/null 2>&1; then open "$REPORT" || true; fi
else
 echo "ERROR: benchmark did not produce a report" >&2
 exit 1
fi
