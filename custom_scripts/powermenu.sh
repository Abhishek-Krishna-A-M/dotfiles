#!/usr/bin/env bash
# Optimized Power Menu for 4GB RAM [cite: 11]

options="Lock\nLogout\nReboot\nPower Off\nSleep"

# Use 'dmenu' or 'dmenu-fuzzy' depending on your installed binary name
chosen=$(echo -e "$options" | dmenu -i -l 5 -p "System:" \
-nb "#f2f2f2" -nf "#1a1a1a" -sb "#000000" -sf "#ffffff" \
    -fn "FiraCode Nerd Font:size=10")

case "$chosen" in
    "Lock")  ~/.config/custom_scripts/lock.sh ;;
    "Logout")    bspc quit ;;
    "Reboot")    systemctl reboot ;;
    "Power Off") systemctl poweroff ;;
    "Sleep")     systemctl suspend ;; # FIXED: Changed 'hospital' to 'suspend'
esac
