#!/usr/bin/env bash

# Misty White Theme for dmenu/scripts
BG="#f2f2f2"     
FG="#1a1a1a"     
SEL_BG="#000000"  
SEL_FG="#ffffff"  

# Custom Rofi styling for the 3-option display selector (Fixed flag)
chosen=$(printf "󰹑 Mirror\n󰍺 Extend\n󰑓 Reset" | rofi -dmenu -nowm -i -p "󰍹 Display:" \
    -theme-str "listview { lines: 3; } window { width: 20%; }")


case "$chosen" in
    󰹑 Mirror)  bash ~/.config/bspwm/scripts/mirror.sh ;;
    󰍺 Extend)  bash ~/.config/bspwm/scripts/extend.sh ;;
    󰑓 Reset)
        # Re-enable laptop screen FIRST to prevent X11 crash/TTY dump
        xrandr --output eDP-1 --auto --primary
        sleep 1
        xrandr --output HDMI-1 --off
        ;;
    *) exit 0 ;;
esac

# Restart UI elements once hardware is stable
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar main &
