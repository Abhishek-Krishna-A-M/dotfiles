#!/bin/bash

if xrandr | grep -q "^HDMI-1 connected"; then
    echo "%{F#a6e3a1}󰍹 HDMI ON%{F-}"
fi

