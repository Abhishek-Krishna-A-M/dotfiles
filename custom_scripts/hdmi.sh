#!/usr/bin/env bash

# Misty White Theme for dmenu/scripts
BG="#f2f2f2"     
FG="#1a1a1a"     
SEL_BG="#000000"  
SEL_FG="#ffffff"  

chosen=$(printf "Mirror\nExtend\nReset" | dmenu -i -l 3 -p "Display:" \
    -nb "$BG" -nf "$FG" -sb "$SEL_BG" -sf "$SEL_FG" \
    -fn "FiraCode Nerd Font:size=10")

# Kill compositor to stop flicker and resource heavy rendering during switch
killall picom 2>/dev/null

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

# Stabilization: Let the hardware settle before moving workspaces
sleep 1.5
bspc wm -r

# Universal Network Recovery for Atheros QCA9377
if ! ping -c 1 8.8.8.8 &>/dev/null; then
    sudo modprobe -r ath10k_pci && sudo modprobe ath10k_pci
    sudo systemctl restart NetworkManager
fi

# Restart UI elements once hardware is stable
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar main &
picom -b &
