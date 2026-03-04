{ pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # 🔁 Kernel switcher
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Examples:
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_lts;
}
