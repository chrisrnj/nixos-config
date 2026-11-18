{ lib, ... }:

{
  imports = [
    ./asahi
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./programs
    ./ssh
  ];

  # Currently failing to compile on aarch64.
  services.scx-loader.enable = lib.mkForce false;

  nixpkgs.hostPlatform = "aarch64-linux";

  fileSystems = {
    "/".options = [ "compress=zstd" "noatime" ];
    "/home".options = [ "compress=zstd" "noatime" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  services.xserver.xkb = {
    layout = "us";
    model = "apple";
    variant = "alt-intl";
  };

  console.keyMap = "us";

  system.stateVersion = "26.11";
}
