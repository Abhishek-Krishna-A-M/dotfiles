#!/usr/bin/dash

ICON_CONNECTED=""
ICON_DISCONNECTED="󰖪"

get_wifi() {
    ssid=$(nmcli -t -f active,ssid dev wifi | sed -n 's/^yes://p')
    if [ -n "$ssid" ]; then
        echo "$ICON_CONNECTED $ssid"
    else
        echo "$ICON_DISCONNECTED"
    fi
}

# initial output
get_wifi

# listen for network changes (NO polling)
nmcli monitor | while read -r _; do
    get_wifi
done
