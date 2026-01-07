#!/usr/bin/env bash

# Optimized Power Menu for 4GB RAM
# Path: ~/.config/rofi/scripts/powermenu.sh

options=" Lock\n󰍃 Logout\n Reboot\n Power Off\n󰤄 Sleep"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "System" \
    -theme-str 'window {width: 400px;} listview {lines: 5;}')

case "$chosen" in
    " Lock") pkill -USR1 rofi
sleep 0.1
i3lock --blur 8 --indicator --clock --inside-color=1e1e2eFF \
--date-str="%a %b %d" \
--time-str="%I:%M %p" \
--ring-color=89b4fa \
--line-color=00000000 \
--keyhl-color=f38ba8 \
--bshl-color=f38ba8 \
--separator-color=00000000 \
--time-color=89b4faFF \
--date-color=89b4faFF \
--time-font="FiraCode Nerd Font" \
--date-font="FiraCode Nerd Font" ;;
    "󰍃 Logout") bspc quit ;;
    " Reboot") systemctl reboot ;;
    " Power Off") systemctl poweroff ;;
    "󰤄 Sleep") systemctl suspend ;;
esac
