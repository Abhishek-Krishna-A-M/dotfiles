#!/usr/bin/dash
LAPTOP="eDP-1"
HDMI="HDMI-1"

# 1. Get the best resolution for HDMI
BEST_MODE=$(xrandr | awk "/^$HDMI connected/ { getline; print \$1; exit }")

if [ -z "$BEST_MODE" ]; then
    echo "HDMI not found or disconnected."
    exit 1
fi

# 2. Set the physical layout (Standard --right-of)
xrandr --output "$LAPTOP" --auto --primary \
       --output "$HDMI" --mode "$BEST_MODE" --right-of "$LAPTOP"

# 3. Re-allocate desktops correctly
# bspc desktop [name] -m [monitor]
for d in 1 2 3 4 5; do
    bspc desktop "$d" -m "$LAPTOP"
done

for d in 6 7 8 9 10; do
    # Try to move the desktop; if it doesn't exist, create it on HDMI
    bspc desktop "$d" -m "$HDMI" 2>/dev/null || bspc monitor "$HDMI" -a "$d"
done

# 4. Clean up the 'Desktop' placeholder bspwm creates
bspc desktop Desktop --remove 2>/dev/null

# 5. Restart Polybar for all monitors
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar on each connected monitor
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main &
done
