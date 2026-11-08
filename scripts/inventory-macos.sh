#!/bin/zsh
set -eu
mkdir -p results/local
{ /usr/sbin/system_profiler SPHardwareDataType SPDisplaysDataType; sw_vers; rustc --version; cargo --version; xcodebuild -version; } > results/local/hardware.txt
echo "Inventory saved to results/local/hardware.txt (review identifiers before sharing)"
