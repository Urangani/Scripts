#!/usr/bin/env bash
# list-agents.sh - detect installed AI agent CLIs and how they were installed

set -euo pipefail

agents=(opencode claude openai ollama anthropic deepseek)
os="$(uname -s)"

echo "🔍 Detecting installed AI agents..."
echo "-----------------------------------"

for agent in "${agents[@]}"; do
    printf "Checking for %s...\n" "$agent"

    if ! path=$(command -v "$agent" 2>/dev/null); then
        echo "❌ $agent not found."
        echo
        continue
    fi

    echo "✅ Found $agent at: $path"

    case "$path" in
        /snap/*)  echo "   Installed via Snap." ; echo ; continue ;;
        /app/*|/flatpak/*) echo "   Installed via Flatpak." ; echo ; continue ;;
    esac

    if [[ "$os" == "Linux" ]] && command -v dpkg >/dev/null 2>&1 && dpkg -S "$path" >/dev/null 2>&1; then
        pkg=$(dpkg -S "$path" | cut -d: -f1)
        echo "   Installed via apt/dpkg package: $pkg"
        echo
        continue
    fi

    if [[ "$os" == "Linux" ]] && command -v rpm >/dev/null 2>&1 && rpm -qf "$path" >/dev/null 2>&1; then
        echo "   Installed via rpm package: $(rpm -qf "$path")"
        echo
        continue
    fi

    if command -v brew >/dev/null 2>&1 && brew list --versions "$agent" >/dev/null 2>&1; then
        echo "   Installed via Homebrew: $(brew list --versions "$agent")"
        echo
        continue
    fi

    if [[ "$path" == "/usr/local/bin/"* || "$path" == "$HOME/bin/"* ]]; then
        echo "   Likely installed manually or via curl script."
    else
        echo "   Installation method unknown."
    fi
    echo
done

echo "-----------------------------------"
echo "Detection complete."