{ pkgs, ... }:

{
   programs.firefox.enable =true;
   programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
  environment.systemPackages = with pkgs; [

    # 📋 Clipboard
    cliphist
    xclip

    # 📸 Screenshot
    flameshot

    # 🔊 Media control
    playerctl

    # 💡 Brightness
    brightnessctl

    # 🌐 Browser

    # 🛠 CLI essentials
    vim neovim git wget curl tree fastfetch
  ];
}
