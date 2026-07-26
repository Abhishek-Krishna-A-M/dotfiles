git clone git@github.com:Abhishek-Krishna-A-M/dotfiles.git ~/dotfiles

# 2. Re-create the symlinks pointing ~/.config back to ~/dotfiles
CONFIGS=(
  alacritty astro bspwm btop cava custom_scripts dconf dunst fish 
  flameshot foot fuzzel gh gtk-3.0 gtk-4.0 helix htop lazygit lf 
  mako mpv nvim opencode picom pipewire polybar rofi sway swaylock 
  sxhkd waybar xdg-desktop-portal xdg-desktop-portal-wlr 
  libinput-gestures.conf mimeapps.list pavucontrol.ini QtProject.conf
)

for item in "${CONFIGS[@]}"; do
  rm -rf "$HOME/.config/$item"
  ln -s "$HOME/dotfiles/config/$item" "$HOME/.config/$item"
done
