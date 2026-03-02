#!/usr/bin/env bash

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
    ["google"]="www.google.com"
    ["duck"]="duckduckgo.com"
)

# 2. If no input, show the list for Rofi
if [ -z "$1" ]; then
    echo ":d <query> ➜ DuckDuckGo Search"
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

elif [[ "$INPUT" =~ ^:d\  ]]; then
    # -- ROUTE 2: DuckDuckGo Search (:d ) --
    QUERY=$(echo "$INPUT" | sed 's/^:d //; s/ /+/g')
    TARGET="https://duckduckgo.com/?q=$QUERY"

elif [[ "$INPUT" =~ ^(s\ |\?\ ) ]]; then
    # -- ROUTE 3: Forced General Search (Google) --
    QUERY=$(echo "$INPUT" | sed 's/^[s?] //; s/ /+/g')
    TARGET="https://www.google.com/search?q=$QUERY"

elif [[ "$INPUT" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}(/.*)?$ ]]; then
    # -- ROUTE 4: Direct URL (e.g., nix.dev) --
    TARGET="$INPUT"
    [[ "$TARGET" != http* ]] && TARGET="https://$TARGET"

elif [[ "$INPUT" =~ ^[^[:space:]]+$ ]]; then
    # -- ROUTE 5: Single Word -> Google "I'm Feeling Lucky" --
    TARGET="https://www.google.com/search?btnI=1&q=$INPUT"

else
    # -- ROUTE 6: General Search (Google) --
    QUERY=$(echo "$INPUT" | sed 's/ /+/g')
    TARGET="https://www.google.com/search?q=$QUERY"
fi

# 4. EXECUTION
coproc ( qutebrowser "$TARGET" > /dev/null 2>&1 )

exit 0
