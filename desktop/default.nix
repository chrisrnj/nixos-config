{ ... }:

{
  imports = [
    ./amdgpu
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./networking
    ./programs
    ./ssh
#     ./virtualisation
    ../optional/kernels/cachyos-kernel.nix
    ../optional/secureboot
  ];

  fileSystems = {
    "/".options = [ "compress=zstd" "noatime" ];
    "/home".options = [ "compress=zstd" "noatime" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/persist".options = [ "compress=zstd" "noatime" ];
  };

  services.xserver.xkb.layout = "br";

  console.keyMap = "br-abnt2";

  # Enable automatic login for the user.
  services.displayManager.autoLogin = {
    enable = true;
    user = "christiano";
  };

  system.stateVersion = "25.11";
}
