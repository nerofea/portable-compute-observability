#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == Darwin ]] || exit 2
command -v xcrun >/dev/null || exit 2
mkdir -p results/local
echo "Available Instruments templates:"
xcrun xctrace list templates
echo "To profile, select a supported template and run:"
echo 'xcrun xctrace record --template "Metal System Trace" --output results/local/metal-trace.trace --launch -- results/local/metal-primitives 1048576 30 17'
echo "Template availability and invocation differ by Xcode version; verify before execution."
