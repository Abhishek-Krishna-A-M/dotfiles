#!/bin/sh

# Ensure the runtime directory is explicitly set for non-systemd environments
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
fi

# 1. Clear out any hanging or partially failed instances cleanly
pkill -u "$USER" -x "pipewire|wireplumber|pipewire-pulse" >/dev/null 2>&1
sleep 0.1

# 2. Start core PipeWire daemon silently
pipewire >/dev/null 2>&1 &

# 3. Active Poll: Wait for PipeWire's socket to actually exist (max 5 seconds)
COUNT=0
while [ ! -S "$XDG_RUNTIME_DIR/pipewire-0" ] && [ $COUNT -lt 50 ]; do
    sleep 0.1
    COUNT=$((COUNT + 1))
done

# 4. Start WirePlumber session manager silently
wireplumber >/dev/null 2>&1 &
sleep 0.5

# 5. Ensure the pulse subdirectory exists before binding the socket
mkdir -p "$XDG_RUNTIME_DIR/pulse"

# 6. Replace this shell process with pipewire-pulse silently
exec pipewire-pulse >/dev/null 2>&1
