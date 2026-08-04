{
  services.printing.enable=true;
  time.timeZone = "Asia/Kolkata";
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  zramSwap = {
    enable = true;
    memoryPercent = 75;
  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  hardware.graphics.enable=true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;


}
