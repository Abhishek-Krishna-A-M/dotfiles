{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    wget
    fastfetch
    curl
    htop
    librewolf
  ];
}
