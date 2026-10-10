#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v xcodebuild >/dev/null 2>&1; then
    echo "ОШИБКА: xcodebuild не найден; для сборки macOS нужен Xcode." >&2
    exit 1
fi

# The AirportItlwm SPI/vtable contract is selected at compile time by
# __IO80211_TARGET and the vendored headers under include/Airport (they branch
# only on __IO80211_TARGET, never on the SDK version). The SDK therefore does
# not affect the kext ABI: every variant is built against the default (newest)
# installed macOS SDK, and only MACOSX_DEPLOYMENT_TARGET differs per variant.

# Run through bash so the helper does not require the executable bit.
bash scripts/setup_mackernelsdk.sh

DERIVED_DATA="$ROOT_DIR/build-tahoe"
PRODUCTS="$DERIVED_DATA/Debug"

rm -rf "$DERIVED_DATA"

# Native AirportItlwm-Sequoia / -Tahoe targets also exist in the project (for
# Xcode GUI builds). This script still drives a single build path through the
# Sonoma 14.4 source graph (AirportItlwmV2 + AirportItlwmSkywalkInterface, gated
# on __IO80211_TARGET) and switches the contract gate via
# GCC_PREPROCESSOR_DEFINITIONS on the command line, so all three variants are
# produced by one code path.
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
    local sdkroot="$5"

    echo
    echo "========================================"
    echo "Building AirportItlwm ${label} (__IO80211_TARGET=${target_macro}, SDKROOT=${sdkroot})..."
    echo "========================================"

    # Xcode 15+ defaults to Apple's new linker (ld-prime), which reorders and
    # rewrites kext vtables. OpenCore's OCAK then reports
    # "Vtable patching failed" and the injection fails with "Invalid Parameter".
    # Forcing the classic ld64 linker keeps the vtable layout the kernel and
    # OpenCore expect. (-ld_classic is still supported by Xcode 26.x.)
    xcodebuild \
        -project itlwm.xcodeproj \
        -target "AirportItlwm-Sonoma14.4" \
        -configuration Debug \
        -sdk "$sdkroot" \
        CONFIGURATION_BUILD_DIR="$PRODUCTS/$label" \
        GCC_PREPROCESSOR_DEFINITIONS='$(inherited) AIRPORT __PRIVATE_SPI__ IO80211FAMILY_V2 __IO80211_TARGET='"$target_macro" \
        INFOPLIST_FILE="$infoplist" \
        MACOSX_DEPLOYMENT_TARGET="$deployment" \
        OTHER_LDFLAGS="-Wl,-ld_classic" \
        SDKROOT="$sdkroot" \
        GIT_COMMIT=_local

    if [ -d "$PRODUCTS/$label/AirportItlwm.kext" ]; then
        rm -rf "$ROOT_DIR/AirportItlwm-$label.kext"
        cp -R "$PRODUCTS/$label/AirportItlwm.kext" "$ROOT_DIR/AirportItlwm-$label.kext"

        if [[ "$sdkroot" =~ ^macosx[0-9] ]]; then
            local expected_sdkroot="$sdkroot"
            local bundle="$ROOT_DIR/AirportItlwm-$label.kext"
            local plist="$bundle/Contents/Info.plist"
            local executable="$bundle/Contents/MacOS/AirportItlwm"
            local expected_major="${expected_sdkroot#macosx}"
            local actual_sdk_major
            local actual_platform_major
            local actual_sdkroot
            local actual_platform_version

            expected_major="${expected_major%%.*}"
            if [ ! -f "$executable" ]; then
                echo "ОШИБКА: в bundle отсутствует executable $executable" >&2
                exit 1
            fi
            if ! /usr/bin/plutil -lint "$plist" >/dev/null; then
                echo "ОШИБКА: некорректный Info.plist: $plist" >&2
                exit 1
            fi
            actual_sdkroot="$(/usr/libexec/PlistBuddy -c 'Print :DTSDKName' "$plist")"
            actual_platform_version="$(/usr/libexec/PlistBuddy -c 'Print :DTPlatformVersion' "$plist")"
            actual_sdk_major="${actual_sdkroot#macosx}"
            actual_sdk_major="${actual_sdk_major%%.*}"
            actual_platform_major="${actual_platform_version%%.*}"
            if [ "$actual_sdk_major" != "$expected_major" ] || [ "$actual_platform_major" != "$expected_major" ]; then
                echo "ОШИБКА: SDK metadata не совпадает с запрошенным SDKROOT=$expected_sdkroot:" >&2
                echo "  DTSDKName=$actual_sdkroot, DTPlatformVersion=$actual_platform_version" >&2
                exit 1
            fi
        fi

        echo "-> $ROOT_DIR/AirportItlwm-$label.kext"
    else
        echo "ОШИБКА: kext не собран ($PRODUCTS/$label/AirportItlwm.kext)" >&2
        exit 1
    fi
}

build_airport_variant "Sonoma14.4" "__MAC_14_4" "10.15" "AirportItlwm/AirportItlwm-Sonoma-Info.plist" "macosx"
build_airport_variant "Sequoia" "__MAC_15_0" "15.0" "AirportItlwm/AirportItlwm-Sequoia-Info.plist" "macosx"
build_airport_variant "Tahoe" "__MAC_26_0" "26.0" "AirportItlwm/AirportItlwm-Tahoe-Info.plist" "macosx"

echo
echo "========================================"
echo "AirportItlwm builds complete"
echo "========================================"
find "$PRODUCTS" -maxdepth 2 -name '*.kext' -print
echo "-- копии в корне проекта:"
find "$ROOT_DIR" -maxdepth 1 -name 'AirportItlwm-*.kext' -print

# Выгружаем собранные kext в git-репо (артефакты-версии, чтобы их можно было
# забрать на любой машине / для OpenCore). Push не фатален: если репо недоступно,
# kext остаются в корне.
if [ -d .git ]; then
    git add AirportItlwm-Sonoma14.4.kext AirportItlwm-Sequoia.kext AirportItlwm-Tahoe.kext 2>/dev/null || true
    if git diff --cached --quiet; then
        echo "kext: изменений относительно последнего коммита нет"
    else
        git commit -m "kext: AirportItlwm variants ($(date '+%Y-%m-%d %H:%M'))"
        git push origin HEAD 2>/dev/null || echo "kext: push не удался (офлайн/нет прав) — kext остались локально"
    fi
else
    echo "не git-репо — kext остаются в корне"
fi