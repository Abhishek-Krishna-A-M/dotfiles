#!/usr/bin/env bash
# Optimized Power Menu for 4GB RAM

options="Lock\nLogout\nReboot\nPower Off\nSleep"

# Custom Rofi styling to match your Artix Mountain theme
chosen=$(echo -e "$options" | rofi -dmenu -nowm -i -p "System:" \
   -theme-str "listview { lines: 5; } window { width: 25%; }")

case "$chosen" in
    "Lock")      
        ~/.config/custom_scripts/lock.sh ;;
    "Logout")    
        bspc quit ;;
    "Reboot")    
        loginctl reboot ;;
    "Power Off") 
        loginctl poweroff ;;
    "Sleep")     
        # Lock, wait a tiny bit, kill the display signal, then suspend
        ~/.config/custom_scripts/lock.sh & 
        sleep 0.5 && xset dpms force off && loginctl suspend ;;
esac
