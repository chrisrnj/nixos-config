{ ... }:

{
  hardware.asahi.enable = true;

  boot = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };
}
