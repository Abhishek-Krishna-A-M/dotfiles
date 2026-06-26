#!/usr/bin/env bash
selection=$(
  wlrctl toplevel list |
    fuzzel --no-icons --dmenu --prompt="󱂬 Switch: "
)
[ -z "$selection" ] && exit 0

# wlrctl toplevel list outputs: "app_id: title"
app_id="${selection%%: *}"
title="${selection#*: }"

if [ -n "$app_id" ] && [ "$app_id" != "null" ]; then
  wlrctl toplevel focus app_id:"$app_id"
else
  wlrctl toplevel focus title:"$title"
fi
