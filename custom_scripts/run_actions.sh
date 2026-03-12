#!/usr/bin/env bash

# Path to your main script 
SCRIPT="$HOME/.config/custom_scripts/actions.sh"

# 1. Get the list and capture the user choice 
# Using your exact Catppuccin-inspired colors [cite: 1, 2]
choice=$("$SCRIPT" | dmenu -l 1 -p "󰖟 Search:" \
-nb "#f2f2f2" -nf "#1a1a1a" -sb "#000000" -sf "#ffffff" \
    -fn "FiraCode Nerd Font:size=10")

# 2. If the user didn't hit Escape, pass the choice back to the script 
if [ -n "$choice" ]; then
    "$SCRIPT" "$choice"
fi
