#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SDK_DIR="$ROOT_DIR/MacKernelSDK"
SDK_REPO="https://github.com/acidanthera/MacKernelSDK.git"

if [ -f "$SDK_DIR/Headers/libkern/libkern.h" ] && [ -f "$SDK_DIR/Headers/mach/mach_types.h" ]; then
    echo "MacKernelSDK: already installed at $SDK_DIR"
    exit 0
fi

if [ -e "$SDK_DIR" ]; then
    echo "MacKernelSDK directory exists but is incomplete: $SDK_DIR" >&2
    echo "Remove it and run this script again." >&2
    exit 1
fi

echo "Cloning MacKernelSDK..."
git clone --depth=1 "$SDK_REPO" "$SDK_DIR"

echo "MacKernelSDK installed successfully."
