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

# The project does not yet contain a native Tahoe-specific AirportItlwm target.
# Sonoma 14.4 is the newest existing AirportItlwm target, so reuse its source/build
# graph while overriding the deployment target and output directory for Tahoe.
echo
echo "========================================"
echo "Building AirportItlwm Tahoe variant..."
echo "========================================"

TAHOE_PRODUCTS="$DERIVED_DATA/Build/Products/Debug/Tahoe"
mkdir -p "$TAHOE_PRODUCTS"

xcodebuild \
    -project itlwm.xcodeproj \
    -target "AirportItlwm-Sonoma14.4" \
    -configuration Debug \
    -derivedDataPath "$DERIVED_DATA" \
    CONFIGURATION_BUILD_DIR="$TAHOE_PRODUCTS" \
    MACOSX_DEPLOYMENT_TARGET=26.0 \
    GIT_COMMIT=_local

echo
echo "========================================"
echo "Tahoe build complete"
echo "========================================"
find "$DERIVED_DATA/Build/Products" -maxdepth 3 -name '*.kext' -print
