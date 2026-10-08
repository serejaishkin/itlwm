#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v xcodebuild >/dev/null 2>&1; then
    echo "ОШИБКА: xcodebuild не найден; для сборки macOS нужен Xcode." >&2
    exit 1
fi

if ! SDK_LIST="$(xcodebuild -showsdks 2>&1)"; then
    echo "ОШИБКА: не удалось получить список установленных SDK через xcodebuild -showsdks:" >&2
    printf '%s\n' "$SDK_LIST" >&2
    exit 1
fi

sdkroot_for_major() {
    local major="$1"
    local sdkroot

    sdkroot="$(printf '%s\n' "$SDK_LIST" | awk -v major="$major" '
        {
            for (i = 1; i < NF; i++) {
                if ($i != "-sdk" || $(i + 1) !~ /^macosx[0-9]/) {
                    continue
                }

                id = $(i + 1)
                version = id
                sub(/^macosx/, "", version)
                parts = split(version, component, ".")
                if (component[1] + 0 != major + 0) {
                    continue
                }

                minor = parts > 1 ? component[2] + 0 : 0
                patch = parts > 2 ? component[3] + 0 : 0
                if (!found || minor > best_minor || (minor == best_minor && patch > best_patch)) {
                    found = 1
                    best_minor = minor
                    best_patch = patch
                    best_id = id
                }
            }
        }
        END {
            if (found) {
                print best_id
            }
        }
    ')"

    if [ -z "$sdkroot" ]; then
        echo "ОШИБКА: не найден macOS ${major}.x SDK. Установленные SDK:" >&2
        printf '%s\n' "$SDK_LIST" >&2
        exit 1
    fi

    printf '%s' "$sdkroot"
}

SEQUOIA_SDKROOT="$(sdkroot_for_major 15)"
TAHOE_SDKROOT="$(sdkroot_for_major 26)"

check_sdkroot() {
    local sdkroot="$1"
    local sdk_version="${sdkroot#macosx}"
    local sdk_info

    if ! sdk_info="$(xcodebuild -version -sdk "$sdkroot" 2>&1)"; then
        echo "ОШИБКА: SDKROOT=$sdkroot недоступен через xcodebuild:" >&2
        printf '%s\n' "$sdk_info" >&2
        exit 1
    fi
    if ! printf '%s\n' "$sdk_info" | grep -Fqx "SDKVersion: $sdk_version"; then
        echo "ОШИБКА: xcodebuild не подтвердил SDK $sdkroot:" >&2
        printf '%s\n' "$sdk_info" >&2
        exit 1
    fi
}

check_sdkroot "$SEQUOIA_SDKROOT"
check_sdkroot "$TAHOE_SDKROOT"

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
    local sdkroot="$5"

    echo
    echo "========================================"
    echo "Building AirportItlwm ${label} (__IO80211_TARGET=${target_macro}, SDKROOT=${sdkroot})..."
    echo "========================================"

    xcodebuild \
        -project itlwm.xcodeproj \
        -target "AirportItlwm-Sonoma14.4" \
        -configuration Debug \
        -sdk "$sdkroot" \
        CONFIGURATION_BUILD_DIR="$PRODUCTS/$label" \
        GCC_PREPROCESSOR_DEFINITIONS='$(inherited) AIRPORT __PRIVATE_SPI__ IO80211FAMILY_V2 __IO80211_TARGET='"$target_macro" \
        INFOPLIST_FILE="$infoplist" \
        MACOSX_DEPLOYMENT_TARGET="$deployment" \
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
build_airport_variant "Sequoia" "__MAC_15_0" "15.0" "AirportItlwm/AirportItlwm-Sequoia-Info.plist" "$SEQUOIA_SDKROOT"
build_airport_variant "Tahoe" "__MAC_26_0" "26.0" "AirportItlwm/AirportItlwm-Tahoe-Info.plist" "$TAHOE_SDKROOT"

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