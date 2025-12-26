#!/bin/sh

# Read current SSID
ssid=$(nmcli -t -f ACTIVE,SSID dev wifi \
  | grep '^yes' | cut -d: -f2)

# If no SSID => offline
if [ -z "$ssid" ]; then
  echo "󰤭 Disconnected"
  exit 0
fi

# Read signal % for the used AP
signal=$(nmcli -t -f IN-USE,SIGNAL dev wifi \
  | grep '^\*' | cut -d: -f2)

# Defensive check
case $signal in
  ''|*[!0-9]*)
    icon="󰤯" ;; # default lowest if weird value
  *)
    if   [ "$signal" -ge 80 ]; then icon="󰤨"
    elif [ "$signal" -ge 60 ]; then icon="󰤥"
    elif [ "$signal" -ge 40 ]; then icon="󰤢"
    elif [ "$signal" -ge 20 ]; then icon="󰤟"
    else                            icon="󰤯"
    fi ;;
esac

echo "$icon $ssid"

