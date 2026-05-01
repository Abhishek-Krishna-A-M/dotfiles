#!/usr/bin/env bash

# Misty White Theme for dmenu/scripts
BG="#f2f2f2"     
FG="#1a1a1a"     
SEL_BG="#000000"  
SEL_FG="#ffffff"  

chosen=$(printf "Mirror\nExtend\nReset" | dmenu -i -l 3 -p "Display:" \
	-nb "#000409" \
	-nf "#ffffff" \
	-sb "#f2f2f2" \
	-sf "#000409" \
    -fn "FiraCode Nerd Font:size=10")


case "$chosen" in
    Mirror)  bash ~/.config/bspwm/scripts/mirror.sh ;;
    Extend)  bash ~/.config/bspwm/scripts/extend.sh ;;
    Reset)
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
