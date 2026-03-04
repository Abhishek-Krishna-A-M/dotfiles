{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  services.printing.enable=true;
  time.timeZone = "Asia/Kolkata";
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
}
