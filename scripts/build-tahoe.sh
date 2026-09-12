#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# Run through bash so the helper does not require the executable bit.
bash scripts/setup_mackernelsdk.sh

DERIVED_DATA="$ROOT_DIR/build-tahoe"
rm -rf "$DERIVED_DATA"

build_scheme() {
    local scheme="$1"

    echo
    echo "========================================"
    echo "Building ${scheme} for macOS 26 (Tahoe)..."
    echo "========================================"

    xcodebuild \
        -project itlwm.xcodeproj \
        -scheme "$scheme" \
        -configuration Debug \
        -derivedDataPath "$DERIVED_DATA" \
        MACOSX_DEPLOYMENT_TARGET=26.0 \
        GIT_COMMIT=_local
}

# Standard itlwm (Ethernet-style interface).
build_scheme "itlwm"

# AirportItlwm (IO80211Family-based Wi-Fi interface).
build_scheme "AirportItlwm (all)"

echo
echo "========================================"
echo "Tahoe build complete"
echo "========================================"
find "$DERIVED_DATA/Build/Products" -maxdepth 3 -name '*.kext' -print
