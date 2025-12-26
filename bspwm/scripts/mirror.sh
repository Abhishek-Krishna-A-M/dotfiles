#!/bin/bash

LAPTOP="eDP-1"
HDMI="HDMI-1"

MODE=$(xrandr | awk -v l="$LAPTOP" '
    $0 ~ l {found=1}
    found && /\*/ {print $1; exit}
')

if [ -z "$MODE" ]; then
    echo "Error: Could not detect laptop mode."
    exit 1
fi

xrandr --output "$HDMI" --mode "$MODE" --same-as "$LAPTOP" \
       --output "$LAPTOP" --mode "$MODE"
