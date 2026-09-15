#!/usr/bin/env bash
# gh-repos.sh - list GitHub repositories as Markdown
#   --simple (default)  one-shot table to stdout (name/description/stars/forks)
#   --track             maintain github_repos.md, preserving a manual Status column
#
# GitHub username comes from $GH_USER, falling back to the logged-in user.

set -euo pipefail

GITHUB_USER="${GH_USER:-$USER}"
OUTPUT_FILE="./github_repos.md"
mode="${1:-}"

require() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "error: '$1' is required but not installed" >&2
        exit 1
    fi
}

require gh
require jq

trim() {
    local s="$*"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s' "$s"
}

list_repos() {
    gh repo list "$GITHUB_USER" \
        --json name,description,stargazerCount,forkCount,visibility,updatedAt \
        --limit 100 \
        --jq '.[] | [
            .name,
            ((.description // "No description") | gsub("\n"; " ")),
            (.stargazerCount | tostring),
            (.forkCount | tostring),
            .visibility,
            .updatedAt
        ] | join("|")'
}

simple() {
    echo "| Name | Description | ⭐ Stars | 🍴 Forks |"
    echo "|------|-------------|---------|----------|"
    while IFS='|' read -r name desc stars forks _ _; do
        printf "| %s | %s | %s | %s |\n" "$name" "$desc" "$stars" "$forks"
    done < <(list_repos)
}

track() {
    if [[ ! -f "$OUTPUT_FILE" ]]; then
        cat > "$OUTPUT_FILE" <<'MD'
## GitHub Repository Tracker

<!-- AUTO-GENERATED START -->
| Name | Description | Visibility | Last Update | Status |
|------|-------------|------------|-------------|--------|
<!-- AUTO-GENERATED END -->

## Notes
MD
        echo "Created initial $OUTPUT_FILE"
    fi

    declare -A status_map
    while IFS='|' read -r _ name desc visibility updated status _; do
        name=$(trim "$name")
        status=$(trim "$status")
        if [[ -n "$name" && "$name" != "Name" ]]; then
            status_map["$name"]="$status"
        fi
    done < <(grep '^|' "$OUTPUT_FILE")

    table="| Name | Description | Visibility | Last Update | Status |
|------|-------------|------------|-------------|--------|
"

    while IFS='|' read -r name desc _ _ visibility updated; do
        [[ -n "$name" ]] || continue
        status="${status_map[$name]:-In Progress}"
        table+="| $name | $desc | $visibility | $updated | $status |
"
    done < <(list_repos)

    awk -v table="$table" '
        BEGIN { inblock = 0 }
        /<!-- AUTO-GENERATED START -->/ { print; printf "%s", table; inblock = 1; next }
        /<!-- AUTO-GENERATED END -->/ { inblock = 0 }
        !inblock { print }
    ' "$OUTPUT_FILE" > "$OUTPUT_FILE.tmp" && mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"

    echo "Updated: $(pwd)/$OUTPUT_FILE"
}

case "$mode" in
    --simple|"") simple ;;
    --track)     track ;;
    -h|--help)
        echo "Usage: $0 [--simple|--track]"
        echo "  --simple  print a Markdown table to stdout (default)"
        echo "  --track   update github_repos.md, keeping manual Status edits"
        ;;
    *)
        echo "error: unknown option '$mode' (use --simple or --track)" >&2
        exit 1
        ;;
esac