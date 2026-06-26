#!/usr/bin/env bash
set -euo pipefail

URL='https://md.archlinux.org/s/SxbqukK6IA/download'

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

curl -fsSL "$URL" > "$tmp"

echo "List entries: $(wc -l < "$tmp")"

grep '^actual-ai$' "$tmp"

echo "Checking installed packages..."

matches=$(grep -Fxf "$tmp" <(pacman -Qq) || true)

if [[ -n "$matches" ]]; then
    echo "Potentially affected packages found:"
    echo "$matches"
else
    echo "No affected packages found."
fi
