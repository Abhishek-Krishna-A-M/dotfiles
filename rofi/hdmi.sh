#!/usr/bin/env bash

chosen=$(printf "Mirror\nExtend" | \
rofi -dmenu -i -p "Screen Mode" -config ~/.config/rofi/config.rasi)

case "$chosen" in
    Mirror)  ~/.config/bspwm/scripts/mirror.sh ;;
    Extend) ~/.config/bspwm/scripts/extend.sh ;;
esac

