{ ... }:

{
  hardware.asahi.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };
}
