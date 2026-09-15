{ pkgs, ... }:

{
  imports = [
#     ./alvr
    ./sunshine
  ];

  # OpenRGB
  services.hardware.openrgb.enable = true;

  services.wivrn.autoStart = true;
}
