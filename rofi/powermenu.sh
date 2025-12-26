#!/usr/bin/env bash

# Simple Rofi Power Menu using the main config theme
chosen=$(printf " Lock\n󰍃 Logout\n Reboot\n Power Off\n󰤄 Sleep\n󰒲 Hibernate" | \
rofi -dmenu -i -p "Power Menu" -config ~/.config/rofi/config.rasi)

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
    "󰍃 Logout") pkill -KILL -u "$USER" ;;
    " Reboot") systemctl reboot ;;
    " Power Off") systemctl poweroff ;;
    "󰤄 Sleep") ~/.local/bin/dynamic-lock.sh ;;
    "󰒲 Hibernate") systemctl hibernate ;;
esac
