#!/usr/bin/env bash

SCRIPT="$HOME/.config/custom_scripts/actions.sh"

choice=$("$SCRIPT" | ulaunch -d -p "󰖟 Search: ")

if [ -n "$choice" ]; then
    "$SCRIPT" "$choice"
fi
