#!/usr/bin/env bash

# Path to your main script
SCRIPT="$HOME/.config/custom_scripts/actions.sh"

# Get the list and capture the user choice
choice=$("$SCRIPT" | fuzzel --no-icons --dmenu --prompt="󰖟 Search: ")

# If the user didn't hit Escape, pass the choice back to the script
if [ -n "$choice" ]; then
    "$SCRIPT" "$choice"
fi
