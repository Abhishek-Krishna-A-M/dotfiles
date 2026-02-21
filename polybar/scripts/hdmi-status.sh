#!/usr/bin/dash

ICON_ON="󰍹"
ICON_OFF="󰍺"

status() {
    if xrandr | grep -q "HDMI.* connected"; then
        echo "$ICON_ON HDMI"
    else
        echo "$ICON_OFF HDMI"
    fi
}

status

# listen for udev display events
udevadm monitor --subsystem-match=drm | while read -r _; do
    status
done

