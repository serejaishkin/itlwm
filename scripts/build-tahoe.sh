#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# Run through bash so the helper does not require the executable bit.
bash scripts/setup_mackernelsdk.sh

DERIVED_DATA="$ROOT_DIR/build-tahoe"
rm -rf "$DERIVED_DATA"

XCODEBUILD_ARGS=(
    -project itlwm.xcodeproj
    -scheme itlwm
    -configuration Debug
    -derivedDataPath "$DERIVED_DATA"
    MACOSX_DEPLOYMENT_TARGET=26.0
    GIT_COMMIT=_local
)

echo "Building itlwm for macOS 26 (Tahoe)..."
xcodebuild "${XCODEBUILD_ARGS[@]}"

echo
echo "Build complete:"
find "$DERIVED_DATA/Build/Products" -maxdepth 2 -name '*.kext' -print
