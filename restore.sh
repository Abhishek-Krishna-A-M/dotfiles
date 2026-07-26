echo "==> Linking configuration files..."
mkdir -p "$CONFIG_DIR"

CONFIGS=(
  alacritty astro bspwm btop cava custom_scripts dconf dunst fish 
  flameshot foot fuzzel gh gtk-3.0 gtk-4.0 helix htop lazygit lf 
  mako mpv nvim opencode picom pipewire polybar rofi sway swaylock 
  sxhkd waybar xdg-desktop-portal xdg-desktop-portal-wlr 
  libinput-gestures.conf mimeapps.list pavucontrol.ini QtProject.conf
)

for item in "${CONFIGS[@]}"; do
  rm -rf "$CONFIG_DIR/$item"
  ln -s "$DOTFILES_DIR/config/$item" "$CONFIG_DIR/$item"
  echo "Linked: $item"
done

echo "==> Setup complete!"
