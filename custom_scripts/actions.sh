#!/usr/bin/env bash

# 1. Define your Aliases [cite: 1]
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

# 2. STAGE 1: Provide the list for dmenu [cite: 1]
if [ -z "$1" ]; then
    echo ":d <query> ➜ DuckDuckGo"
    for alias in "${!FAVS[@]}"; do
        echo "$alias ➜ ${FAVS[$alias]}"
    done
    exit 0
fi

INPUT="$1"

# Strip the " ➜ ..." suffix from dmenu selection [cite: 1]
CLEAN_INPUT=$(echo "$INPUT" | awk '{print $1}')

# 3. ROUTING LOGIC [cite: 1]
if [[ -n "${FAVS[$CLEAN_INPUT]}" ]]; then
    TARGET="https://${FAVS[$CLEAN_INPUT]}"
elif [[ "$INPUT" =~ ^([0-9]+)$ ]]; then
    PORT="${BASH_REMATCH[1]}"
    TARGET="http://localhost:$PORT"
elif [[ "$INPUT" =~ ^:d\  ]]; then
    QUERY=$(echo "$INPUT" | sed 's/^:d //; s/ /+/g')
    TARGET="https://duckduckgo.com/?q=$QUERY"
elif [[ "$INPUT" =~ ^(s\ |\?\ ) ]]; then
    QUERY=$(echo "$INPUT" | sed 's/^[s?] //; s/ /+/g')
    TARGET="https://www.google.com/search?q=$QUERY"
elif [[ "$INPUT" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}(/.*)?$ ]]; then
    TARGET="$INPUT"
    [[ "$TARGET" != http* ]] && TARGET="https://$TARGET"
else
    QUERY=$(echo "$INPUT" | sed 's/ /+/g')
    TARGET="https://www.google.com/search?q=$QUERY"
fi

# 4. EXECUTION
# Using setsid and & to fully detach from the dmenu process
(setsid waterfox "$TARGET" &) > /dev/null 2>&1
exit 0

exit 0
