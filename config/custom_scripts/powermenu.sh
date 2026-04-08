#!/usr/bin/env bash
# Optimized Power Menu for 4GB RAM

options="Lock\nLogout\nReboot\nPower Off\nSleep"

# Custom dmenu styling to match your Misty White theme
chosen=$(echo -e "$options" | dmenu -i -l 5 -p "System:" \
	-nb "#000409" \
	-nf "#ffffff" \
	-sb "#f2f2f2" \
	-sf "#000409" \
    -fn "FiraCode Nerd Font:size=10")

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
