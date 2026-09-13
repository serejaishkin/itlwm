#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# Run through bash so the helper does not require the executable bit.
bash scripts/setup_mackernelsdk.sh

DERIVED_DATA="$ROOT_DIR/build-tahoe"
PRODUCTS="$DERIVED_DATA/Debug"

rm -rf "$DERIVED_DATA"

# The project has no native Sequoia/Tahoe AirportItlwm targets yet, so the
# Sonoma 14.4 source graph (AirportItlwmV2 + AirportItlwmSkywalkInterface,
# gated on __IO80211_TARGET) is reused and the contract gate is switched via
# GCC_PREPROCESSOR_DEFINITIONS on the command line.
#
# NOTE: a CLI GCC_PREPROCESSOR_DEFINITIONS REPLACES the whole build setting,
# so every define the target lists must be redeclared: AIRPORT, __PRIVATE_SPI__,
# IO80211FAMILY_V2 and the __IO80211_TARGET gate itself.
#
# -target builds must NOT be combined with -derivedDataPath on modern Xcode
# ("-scheme, -testProductsPath, or -xctestrun is required when specifying
# -derivedDataPath"), so the product location is steered via
# CONFIGURATION_BUILD_DIR only.
build_airport_variant() {
    local label="$1"        # e.g. Tahoe
    local target_macro="$2" # e.g. __MAC_26_0
    local deployment="$3"   # e.g. 26.0
    local infoplist="$4"

    echo
    echo "========================================"
    echo "Building AirportItlwm ${label} (__IO80211_TARGET=${target_macro})..."
    echo "========================================"

    xcodebuild \
        -project itlwm.xcodeproj \
        -target "AirportItlwm-Sonoma14.4" \
        -configuration Debug \
        CONFIGURATION_BUILD_DIR="$PRODUCTS/$label" \
        GCC_PREPROCESSOR_DEFINITIONS='$(inherited) AIRPORT __PRIVATE_SPI__ IO80211FAMILY_V2 __IO80211_TARGET='"$target_macro" \
        INFOPLIST_FILE="$infoplist" \
        MACOSX_DEPLOYMENT_TARGET="$deployment" \
        GIT_COMMIT=_local

    if [ -d "$PRODUCTS/$label/AirportItlwm.kext" ]; then
        rm -rf "$ROOT_DIR/AirportItlwm-$label.kext"
        cp -R "$PRODUCTS/$label/AirportItlwm.kext" "$ROOT_DIR/AirportItlwm-$label.kext"
        echo "-> $ROOT_DIR/AirportItlwm-$label.kext"
    else
        echo "ОШИБКА: kext не собран ($PRODUCTS/$label/AirportItlwm.kext)" >&2
        exit 1
    fi
}

build_airport_variant "Sonoma14.4" "__MAC_14_4" "10.15" "AirportItlwm/AirportItlwm-Sonoma-Info.plist"
build_airport_variant "Sequoia" "__MAC_15_0" "15.0" "AirportItlwm/AirportItlwm-Sequoia-Info.plist"
build_airport_variant "Tahoe" "__MAC_26_0" "26.0" "AirportItlwm/AirportItlwm-Tahoe-Info.plist"

echo
echo "========================================"
echo "AirportItlwm builds complete"
echo "========================================"
find "$PRODUCTS" -maxdepth 2 -name '*.kext' -print
echo "-- копии в корне проекта:"
find "$ROOT_DIR" -maxdepth 1 -name 'AirportItlwm-*.kext' -print