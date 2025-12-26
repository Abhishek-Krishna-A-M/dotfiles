#!/usr/bin/env bash

line=$(xset q | grep "Caps Lock")

caps=$(echo "$line" | awk '{print $4}')
num=$(echo "$line" | awk '{print $8}')

caps_label=""
num_label=""

if [ "$caps" = "on" ]; then
    caps_label="󱀍"
fi

if [ "$num" = "on" ]; then
    num_label="󰎠"
fi

echo "$caps_label $num_label"
