#!/usr/bin/env bash
set -euo pipefail

PROJECTS_DIR="$HOME/projects"
GITHUB_USER="Abhishek-Krishna-A-M"

repos=(
  "btechified"
  "gpad"
  "linux-custom"
  "minimal-launcher"
  "portfolio"
  "projectx-omega"
  "quick_file_sender"
  "staffo"
  "stjosephvotingsystem"
  "sway-autotiler:sway_autotiler"
  "swaybar-rust"
  "ubrowser"
  "ushell"
  "uwm"
  "webernyx"
  "webernyx-dashboard:webernyx-dash"
  "webernyx-website-launcher"
)

mkdir -p "$PROJECTS_DIR"

for entry in "${repos[@]}"; do
  if [[ "$entry" == *:* ]]; then
    repo="${entry%%:*}"
    dir="${entry##*:}"
  else
    repo="$entry"
    dir="$entry"
  fi

  target="$PROJECTS_DIR/$dir"

  if [ -d "$target/.git" ]; then
    echo "Pulling $dir..."
    git -C "$target" pull --ff-only
  elif [ -d "$target" ] && [ "$(ls -A "$target" 2>/dev/null)" ]; then
    echo "WARNING: $target exists but is not a git repo, skipping"
  else
    echo "Cloning $repo into $dir..."
    git clone "git@github.com:$GITHUB_USER/$repo.git" "$target"
  fi
done

echo "Done."
