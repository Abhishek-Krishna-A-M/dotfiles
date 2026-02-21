#!/usr/bin/dash
LAPTOP="eDP-1"
HDMI="HDMI-1"

# 1. Reset and Get Res
xrandr --auto
HDMI_RES=$(xrandr | awk "/^$HDMI connected/ { getline; print \$1; exit }")

if [ -z "$HDMI_RES" ]; then
    echo "HDMI is not connected."
    exit 1
fi

# 2. Re-allocate ALL desktops to the LAPTOP first
# This ensures 6-10 don't get lost in the void
for d in {1..10}; do
    bspc desktop "$d" -m "$LAPTOP"
done

# 3. Mirror using --scale-from
xrandr --output "$LAPTOP" --auto --primary \
       --output "$HDMI" --mode "$HDMI_RES" --same-as "$LAPTOP" --scale-from 1366x768

# 4. Remove the HDMI monitor from bspwm's internal list (optional but cleaner)
# This forces bspwm to only care about the laptop screen
bspc monitor "$HDMI" -r 2>/dev/null
