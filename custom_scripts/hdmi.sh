#!/usr/bin/env bash

# Misty White Theme for dmenu/scripts
BG="#f2f2f2"     # Matches the misty sky background
FG="#1a1a1a"     # Deep charcoal text for readability
SEL_BG="#000000"  # High-contrast black for selection (matches Arch logo)
SEL_FG="#ffffff"  # Pure white text when an item is selected

# Use dmenu-fuzzy (or dmenu) for instant display switching
chosen=$(printf "Mirror\nExtend" | dmenu -i -l 2 -p "Display:" \
    -nb "$BG" -nf "$FG" -sb "$SEL_BG" -sf "$SEL_FG" \
    -fn "FiraCode Nerd Font:size=10")

case "$chosen" in
    Mirror)  ~/.config/bspwm/scripts/mirror.sh ;;
    Extend)  ~/.config/bspwm/scripts/extend.sh ;;
esac
