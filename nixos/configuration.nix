{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/boot.nix
    ./modules/core.nix
    ./modules/desktop-bspwm.nix
    ./modules/audio.nix
    ./modules/fonts.nix
    ./modules/laptop.nix
    ./modules/apps.nix
    ./modules/users.nix
  ];

  system.stateVersion = "25.11";
}
