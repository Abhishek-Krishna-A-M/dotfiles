#!/usr/bin/env bash

# Path to your main script 
SCRIPT="$HOME/.config/custom_scripts/actions.sh"

# 1. Get the list and capture the user choice 
choice=$("$SCRIPT" | rofi -dmenu -nowm -i -p "󰖟 Search:" \
    -theme-str "listview { lines: 1; spacing: 0px; } window { width: 32%; }")

# 2. If the user didn't hit Escape, pass the choice back to the script 
if [ -n "$choice" ]; then
    "$SCRIPT" "$choice"
fi
