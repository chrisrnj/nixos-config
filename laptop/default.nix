{ ... }:

{
  imports = [
    ./asahi
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./programs
    ./ssh
  ];

#   boot.blacklistedKernelModules = [ "macsmc-power" ];

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
