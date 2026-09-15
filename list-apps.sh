#!/usr/bin/env bash
# list-apps.sh - list installed apps grouped by desktop-file category
#   ./list-apps.sh              full listing (categories + apps + totals)
#   ./list-apps.sh categories   categories only (counts + totals)
#   ./list-apps.sh Network      filter by a single category

set -euo pipefail

mode="${1:-}"
declare -A apps

shopt -s nullglob

for file in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop; do
    [[ -f "$file" ]] || continue
    name=$(grep -m1 "^Name=" "$file" | cut -d= -f2 || true)
    categories=$(grep -m1 "^Categories=" "$file" | cut -d= -f2 | tr ';' '\n' || true)

    while IFS= read -r category; do
        [[ -n "$category" ]] || continue
        if [[ -z "$mode" || "$mode" == "categories" || "$category" == "$mode" ]]; then
            apps[$category]+="$name\n"
        fi
    done <<< "$categories"
done

shopt -u nullglob

sorted_categories=$(printf "%s\n" "${!apps[@]}" | sort | sed '/^$/d')

total=0

if [[ "$mode" == "categories" ]]; then
    printf "\033[1;36mTotal categories: %d\033[0m\n\n" "$(printf "%s\n" "$sorted_categories" | wc -l)"
fi

while IFS= read -r category; do
    [[ -n "$category" ]] || continue
    count=$(printf "%b" "${apps[$category]}" | sort | uniq | sed '/^$/d' | wc -l)
    total=$((total + count))

    if [[ "$mode" == "categories" ]]; then
        printf "\033[1;34m%s\033[0m (%d apps)\n" "$category" "$count"
    else
        printf "\033[1;34m=== %s (%d apps) ===\033[0m\n" "$category" "$count"
        printf "%b" "${apps[$category]}" | sort | uniq | sed '/^$/d'
        echo
    fi
done <<< "$sorted_categories"

printf "\n\033[1;32mTotal applications across all categories: %d\033[0m\n" "$total"