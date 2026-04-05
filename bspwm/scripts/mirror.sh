#!/bin/sh
LAPTOP="eDP-1"
HDMI="HDMI-1"

# 1. Reset and Get Res
xrandr --output "$HDMI" --off # Temporarily kill HDMI to reset buffer
HDMI_RES=$(xrandr | awk "/^$HDMI connected/ { getline; print \$1; exit }")

if [ -z "$HDMI_RES" ]; then
    echo "HDMI is not connected."
    exit 1
fi

# 2. Re-allocate ALL desktops to LAPTOP (Prevents desktops 6-10 from being 'lost')
for d in $(seq 1 10); do
    bspc desktop "$d" -m "$LAPTOP"
done

# 3. Mirror using your native 1366x768 resolution
# This forces the HDMI to show exactly what your laptop sees
xrandr --output "$LAPTOP" --mode 1366x768 --primary \
       --output "$HDMI" --mode "$HDMI_RES" --same-as "$LAPTOP" --scale-from 1366x768

# 4. Remove HDMI from bspwm indexing so it doesn't think there are two workspaces
bspc monitor "$HDMI" -r 2>/dev/null
bspc wm -r
