#!/usr/bin/env bash

# ═════════════════════════════════════════════════════════════════════════════
# ~/.config/custom_scripts/hdmi.sh
# Native Wayland Display Switcher for UWM + Fuzzel
# Uses wlr-randr for output management (works with uwm's output management protocol)
# ═════════════════════════════════════════════════════════════════════════════

LAPTOP="eDP-1"
HDMI="HDMI-1"

# Check if wlr-randr is available
if ! command -v wlr-randr &>/dev/null; then
    echo "wlr-randr not found. Install it for HDMI management." >&2
    exit 1
fi

chosen=$(printf "󰹑 Mirror\n󰍺 Extend\n󰑓 Reset" | \
    fuzzel --config ~/.config/fuzzel/display.ini \
           --dmenu \
           --prompt="󰍹 Display: ")

# Exit if cancelled
[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Mirror"*)
        # Enable both outputs at same position for mirroring
        wlr-randr --output "$LAPTOP" --on --pos 0,0 --mode 1366x768
        wlr-randr --output "$HDMI" --on --pos 0,0 --mode 1366x768
        ;;
        
    *"Extend"*)
        # Enable laptop on left, HDMI on right
        wlr-randr --output "$LAPTOP" --on --pos 0,0 --mode 1366x768
        wlr-randr --output "$HDMI" --on --pos 1366,0 --mode 1920x1080
        ;;
        
    *"Reset"*)
        # Enable laptop only, disable HDMI
        wlr-randr --output "$LAPTOP" --on --pos 0,0 --mode 1366x768
        sleep 0.3
        wlr-randr --output "$HDMI" --off
        ;;
esac
