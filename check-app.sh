#!/usr/bin/env bash
# check-app.sh - find how an app is installed (dpkg/snap/flatpak/AppImage)
# Usage: ./check-app.sh <app-name>

set -euo pipefail

if [[ -z "${1:-}" ]]; then
    echo "Usage: $0 <app-name>" >&2
    exit 1
fi

APP=$1
found=0

echo "Checking package managers for: $APP"

if dpkg -l 2>/dev/null | grep -w "$APP" >/dev/null; then
    echo "✅ Found in APT/Deb (dpkg)"
    apt show "$APP" 2>/dev/null | grep -E 'Package:|Version:|Installed-Size:' || true
    found=1
fi

if command -v snap >/dev/null 2>&1 && snap list 2>/dev/null | grep -w "$APP" >/dev/null; then
    echo "✅ Found in Snap"
    snap info "$APP" 2>/dev/null | grep -E 'name:|installed:|publisher:' || true
    found=1
fi

if command -v flatpak >/dev/null 2>&1 && flatpak list --columns=application 2>/dev/null | grep -w "$APP" >/dev/null; then
    echo "✅ Found in Flatpak"
    flatpak info "$APP" 2>/dev/null | grep -E 'ID:|Version:|Origin:' || true
    found=1
fi

if [[ "$APP" == *.AppImage ]]; then
    if [[ -f "$APP" ]]; then
        echo "✅ Found as AppImage file: $APP"
        found=1
    else
        echo "ℹ️ AppImage file not found at '$APP'"
    fi
fi

if [[ "$found" -eq 0 ]]; then
    echo "ℹ️ '$APP' not found via dpkg, snap, flatpak, or an AppImage file."
fi