#!/usr/bin/env bash

# Path: ~/.config/rofi/scripts/hdmi.sh

chosen=$(printf "Mirror\nExtend" | rofi -dmenu -i -p "Display" \
    -theme-str 'window {width: 200px;} listview {lines: 2;}')

case "$chosen" in
    Mirror)  ~/.config/bspwm/scripts/mirror.sh ;;
    Extend) ~/.config/bspwm/scripts/extend.sh ;;
esac
