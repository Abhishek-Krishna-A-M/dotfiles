#!/usr/bin/env bash
# Optimized Power Menu for 4GB RAM

options="Lock\nLogout\nReboot\nPower Off\nSleep"

# Custom dmenu styling to match your Misty White theme
chosen=$(echo -e "$options" | dmenu -i -l 5 -p "System:" \
    -nb "#f2f2f2" -nf "#1a1a1a" -sb "#000000" -sf "#ffffff" \
    -fn "FiraCode Nerd Font:size=10")

case "$chosen" in
    "Lock")      
        ~/.config/custom_scripts/lock.sh ;;
    "Logout")    
        bspc quit ;;
    "Reboot")    
        systemctl reboot ;;
    "Power Off") 
        systemctl poweroff ;;
    "Sleep")     
        # Lock, wait a tiny bit, kill the display signal, then suspend
        ~/.config/custom_scripts/lock.sh & 
        sleep 0.5 && xset dpms force off && systemctl suspend ;;
esac
