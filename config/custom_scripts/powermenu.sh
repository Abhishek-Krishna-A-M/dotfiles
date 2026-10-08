#!/usr/bin/env bash

options=" Lock
󰍃 Logout
 Reboot
󰐥 Power Off
󰒲 Sleep"

chosen=$(printf "%s\n" "$options" | \
    ulaunch -d -p " System: ")

case "$chosen" in
    " Lock")
        swaylock
        ;;
    "󰍃 Logout")
        swaymsg exit
        ;;
    " Reboot")
        systemctl reboot
        ;;
    "󰐥 Power Off")
        systemctl poweroff
        ;;
    "󰒲 Sleep")
        swaylock &
        sleep 0.5
        systemctl suspend
        ;;
esac
