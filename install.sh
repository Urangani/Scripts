#!/usr/bin/env bash
# install.sh - symlink this repo's scripts into ~/.local/bin
# Usage: ./install.sh [target-dir]

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="${1:-$HOME/.local/bin}"

scripts=(
    list-apps.sh
    check-app.sh
    gh-repos.sh
    ct_template
    list-agents.sh
    budget_split.py
    clip-board/clipboard.sh
)

mkdir -p "$bin_dir"

for script in "${scripts[@]}"; do
    src="$repo_dir/$script"
    if [[ ! -f "$src" ]]; then
        echo "warning: $src not found, skipping" >&2
        continue
    fi
    name="$(basename "$script")"
    ln -sfn "$src" "$bin_dir/$name"
    echo "linked $name -> $src"
done

echo
echo "Done. Make sure $bin_dir is in your PATH:"
echo "  export PATH=\"$bin_dir:\$PATH\""