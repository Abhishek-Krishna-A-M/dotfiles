#!/usr/bin/env bash

options=" Lock
󰍃 Logout
 Reboot
󰐥 Power Off
󰒲 Sleep"

chosen=$(printf "%s\n" "$options" | \
    fuzzel --no-icons --dmenu --prompt=" System: ")

case "$chosen" in
    " Lock")
        swaylock
        ;;
    "󰍃 Logout")
        swaymsg exit
        ;;
    " Reboot")
        loginctl reboot
        ;;
    "󰐥 Power Off")
        loginctl poweroff
        ;;
    "󰒲 Sleep")
        swaylock &
        sleep 0.5
        loginctl suspend
        ;;
esac
