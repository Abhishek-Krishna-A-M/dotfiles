#!/usr/bin/env bash

# Simple Rofi Power Menu using the main config theme
chosen=$(printf " Lock\n󰍃 Logout\n Reboot\n Power Off\n󰤄 Sleep\n󰒲 Hibernate" | \
rofi -dmenu -i -p "Power Menu" -config ~/.config/rofi/config.rasi)

case "$chosen" in
    " Lock") dm-tool lock ;;
    "󰍃 Logout") pkill -KILL -u "$USER" ;;
    " Reboot") systemctl reboot ;;
    " Power Off") systemctl poweroff ;;
    "󰤄 Sleep") systemctl suspend ;;
    "󰒲 Hibernate") systemctl hibernate ;;
esac
