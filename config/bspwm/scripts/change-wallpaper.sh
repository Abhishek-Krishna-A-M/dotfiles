#!/bin/bash

WALLDIR="$HOME/Pictures/"
RANDOM_WALL=$(find "$WALLDIR" -type f | shuf -n 1)

feh --bg-fill "$RANDOM_WALL"
