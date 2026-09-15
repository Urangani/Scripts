#!/usr/bin/env bash
# clipboard.sh - universal clipboard helper for Linux (Wayland + X11)
#   ./clipboard.sh copy   < input.txt
#   ./clipboard.sh paste

set -euo pipefail

action="${1:-}"

case "$action" in
    copy)
        if [[ -n "${WAYLAND_DISPLAY:-}" ]] && command -v wl-copy >/dev/null 2>&1; then
            wl-copy
        elif command -v xclip >/dev/null 2>&1; then
            xclip -selection clipboard
        elif command -v xsel >/dev/null 2>&1; then
            xsel --clipboard --input
        else
            echo "No clipboard utility found. Install wl-clipboard, xclip, or xsel." >&2
            exit 1
        fi
        ;;
    paste)
        if [[ -n "${WAYLAND_DISPLAY:-}" ]] && command -v wl-paste >/dev/null 2>&1; then
            wl-paste
        elif command -v xclip >/dev/null 2>&1; then
            xclip -selection clipboard -o
        elif command -v xsel >/dev/null 2>&1; then
            xsel --clipboard --output
        else
            echo "No clipboard utility found. Install wl-clipboard, xclip, or xsel." >&2
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {copy|paste}" >&2
        exit 1
        ;;
esac