#!/usr/bin/env bash
LAPTOP="eDP-1"
HDMI="HDMI-1"

# Dynamically find the best resolution
MODE=$(xrandr | awk "/^$HDMI connected/ { getline; print \$1; exit }")
[ -z "$MODE" ] && MODE="1920x1080"

# Explicitly set Laptop first, then extend HDMI
xrandr --output "$LAPTOP" --auto --primary --output "$HDMI" --mode "$MODE" --right-of "$LAPTOP"

# Pause for the i3 CPU/GPU to catch up
sleep 1 

# Re-allocate Desktops: 1-5 Laptop
for i in {1..5}; do 
    bspc desktop "$i" -m "$LAPTOP"
done

# Re-allocate Desktops: 6-10 HDMI
# We use 'bspc monitor -a' to ensure the desktop exists if it wasn't in bspwmrc
for i in {6..10}; do 
    bspc monitor "$HDMI" -a "$i" 2>/dev/null
    bspc desktop "$i" -m "$HDMI"
done

# Clean ghost desktops (important for bspwm stability)
bspc desktop Desktop --remove 2>/dev/null
