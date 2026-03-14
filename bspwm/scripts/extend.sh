#!/usr/bin/env bash
LAPTOP="eDP-1"
HDMI="HDMI-1"

# Dynamically find the best resolution
MODE=$(xrandr | awk "/^$HDMI connected/ { getline; print \$1; exit }")
[ -z "$MODE" ] && MODE="1920x1080"

# Explicitly set Laptop first, then extend HDMI
xrandr --output "$LAPTOP" --auto --primary --output "$HDMI" --mode "$MODE" --right-of "$LAPTOP"

# Pause for your i3 CPU to register the new frame buffer
sleep 1 

# Re-allocate Desktops: 1-5 Laptop, 6-10 HDMI
for i in {1..5}; do 
    bspc desktop "$i" -m "$LAPTOP"
done

for i in {6..10}; do 
    bspc monitor "$HDMI" -a "$i" 2>/dev/null
    bspc desktop "$i" -m "$HDMI"
done

# Clean ghost desktops
bspc desktop Desktop --remove 2>/dev/null
