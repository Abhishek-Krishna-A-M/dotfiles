{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    tree
    ripgrep
    fzf
    yazi
    github-cli
    neovim
    git
    wget
    fastfetch
    curl
    htop
    brave-origin
    foot
    swaybg
    opencode
    grim
    slurp
    brightnessctl
    wl-clipboard
  ];
}
