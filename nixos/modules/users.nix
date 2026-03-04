{
  security.sudo.wheelNeedsPassword = true;

  users.users.ak = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "lp" ];
  };
}
