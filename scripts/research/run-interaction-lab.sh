#!/usr/bin/env bash
set -euo pipefail
python3 scripts/research/test-interaction-lab.py
python3 scripts/research/interaction-lab.py "$@"
