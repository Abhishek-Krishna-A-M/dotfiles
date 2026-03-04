{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.displayManager.ly.enable = true;

  services.displayManager.defaultSession = "none+bspwm";

  environment.systemPackages = with pkgs; [
    bspwm sxhkd xorg.xinit rofi feh picom i3lock
    (polybar.override { pulseSupport = true; })
  ];
}
