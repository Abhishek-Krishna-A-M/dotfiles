#!/bin/bash

LAPTOP="eDP-1"
HDMI="HDMI-1"

BEST_MODE=$(xrandr | awk -v h="$HDMI" '
    $0 ~ h {in=1; next}
    in && NF==1 {in=0}
    in && $0 ~ /^[ ]+[0-9]/ {
        res=$1
        for(i=2;i<=NF;i++){
            if($i ~ /\*/){print res; exit}
        }
    }')

if [ -z "$BEST_MODE" ]; then
    echo "Error: Could not detect HDMI mode."
    exit 1
fi

xrandr --output "$HDMI" --mode "$BEST_MODE" --right-of "$LAPTOP"

bspc monitor "$LAPTOP" -d 1 2 3 4 5
bspc monitor "$HDMI" -d 6 7 8 9 10

