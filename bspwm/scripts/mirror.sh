#!/usr/bin/env bash
LAPTOP="eDP-1"
HDMI="HDMI-1"

# Move all desktops to Laptop so bspwm doesn't panic when HDMI is mirrored
for i in {1..10}; do 
    bspc desktop "$i" -m "$LAPTOP"
done

# Force Laptop to native res and mirror to HDMI with specific scale-from
# This is much lighter on the i3-5005U
xrandr --output "$LAPTOP" --mode 1366x768 --primary \
       --output "$HDMI" --auto --same-as "$LAPTOP" --scale-from 1366x768

# Cleanup: remove HDMI from bspwm indexing to avoid workspace duplication
sleep 0.5
bspc monitor "$HDMI" -r 2>/dev/null
