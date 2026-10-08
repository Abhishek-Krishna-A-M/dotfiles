{
  security.sudo.wheelNeedsPassword = true;
  security.polkit.enable = true;

  users.users.ak = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "lp" ];
  };
}
