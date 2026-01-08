#!/usr/bin/env bash

# Path: ~/.config/rofi/scripts/actions.sh

# 1. Define your Aliases
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

# 2. If no input, show the list for Rofi
if [ -z "$1" ]; then
    for alias in "${!FAVS[@]}"; do
        echo "$alias ➜ ${FAVS[$alias]}"
    done
    exit
fi

INPUT="$1"

# Strip Rofi's " ➜ ..." suffix if a list item was selected
CLEAN_INPUT=$(echo "$INPUT" | awk '{print $1}')

# 3. INTELLIGENT ROUTING LOGIC
if [[ -n "${FAVS[$CLEAN_INPUT]}" ]]; then
    # -- ROUTE 1: Exact Alias Match --
    TARGET="https://${FAVS[$CLEAN_INPUT]}"

elif [[ "$INPUT" =~ ^(s\ |\?\ ) ]]; then
    # -- ROUTE 2: Forced Search --
    # If input starts with "s " or "? ", strip prefix and search
    QUERY=$(echo "$INPUT" | sed 's/^[s?] //; s/ /+/g')
    TARGET="https://www.google.com/search?q=$QUERY"

elif [[ "$INPUT" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}(/.*)?$ ]]; then
    # -- ROUTE 3: Direct URL (already has a dot like "nix.dev") --
    TARGET="$INPUT"
    [[ "$TARGET" != http* ]] && TARGET="https://$TARGET"

elif [[ "$INPUT" =~ ^[^[:space:]]+$ ]]; then
    # -- ROUTE 4: Single Word "I'm Feeling Lucky" --
    # Handles "google", "archlinux", "vlc" etc. regardless of .com/.org
    TARGET="https://www.google.com/search?btnI=1&q=$INPUT"

else
    # -- ROUTE 5: General Search --
    QUERY=$(echo "$INPUT" | sed 's/ /+/g')
    TARGET="https://www.google.com/search?q=$QUERY"
fi

# 4. EXECUTION
# Use mercury-browser-avx2 to launch the final TARGET
coproc ( mercury-browser-avx2 "$TARGET" > /dev/null 2>&1 )

exit 0
