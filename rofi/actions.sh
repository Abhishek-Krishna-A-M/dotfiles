#!/usr/bin/env bash

# Path: ~/.config/rofi/scripts/actions.sh

# 1. Define your Aliases (Key="Alias", Value="Actual URL")
declare -A FAVS=(
    ["yt"]="youtube.com"
    ["gh"]="github.com"
    ["sb"]="supabase.com"
    ["gpt"]="chatgpt.com"
    ["gemini"]="gemini.google.com"
    ["aw"]="wiki.archlinux.org"
    ["red"]="reddit.com"
    ["ym"]="music.youtube.com"
)

# 2. If no input, show the list of aliases for guidance
if [ -z "$1" ]; then
    for alias in "${!FAVS[@]}"; do
        echo "$alias ➜ ${FAVS[$alias]}"
    done
    exit
fi

# 3. Process Input
INPUT="$1"

# Strip the " ➜ ..." part if you selected an item from the list using arrow keys
# This ensures "yt ➜ youtube.com" becomes just "yt"
CLEAN_INPUT=$(echo "$INPUT" | awk '{print $1}')

# 4. ALIAS CHECK: If the input is a shortcut, change it to the full URL
if [[ -n "${FAVS[$CLEAN_INPUT]}" ]]; then
    TARGET="${FAVS[$CLEAN_INPUT]}"
else
    TARGET="$INPUT"
fi

# 5. YOUR ORIGINAL WORKING LOGIC (Unchanged)
if [[ "$TARGET" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}(/.*)?$ ]]; then
    URL="$TARGET"
    [[ "$URL" != http* ]] && URL="https://$URL"
    coproc ( thorium-browser "$URL" > /dev/null 2>&1 )
else
    QUERY=$(echo "$TARGET" | sed 's/ /+/g')
    coproc ( thorium-browser "https://www.google.com/search?q=$QUERY" > /dev/null 2>&1 )
fi

exit 0
