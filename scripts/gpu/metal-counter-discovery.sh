#!/usr/bin/env bash
set -euo pipefail
if [[ "$(uname -s)" != "Darwin" ]]; then echo 'macOS required' >&2; exit 2; fi
if ! command -v xcrun >/dev/null; then echo 'Xcode tools required' >&2; exit 2; fi
xcrun xctrace list templates
printf '\nUse Instruments Metal System Trace for supported GPU counters.\n'
printf 'Counter availability varies by GPU family, Xcode and permissions.\n'
