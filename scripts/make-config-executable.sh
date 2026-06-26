#!/usr/bin/env bash
set -euo pipefail

find "$HOME/dotfiles/config" -type f -exec grep -Il '^#!' {} \; -exec chmod +x {} \;

echo "Made all scripts in config/ executable."
