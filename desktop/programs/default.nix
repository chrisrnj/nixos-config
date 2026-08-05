{ pkgs, ... }:

{
  imports = [
    ./sunshine
  ];

  environment.systemPackages = with pkgs; [
    davinci-resolve
  ];

  # OpenRGB
  services.hardware.openrgb.enable = true;

  # Waydroid
  virtualisation.waydroid.enable = true;
}
