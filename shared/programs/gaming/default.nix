{ lib, pkgs, ... }:

{
  imports = [
    ./prismlauncher.nix
    ./steam
    ./vr
  ];

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos_git;
  };

  # Xbox Controller driver
  hardware.xpadneo.enable = true;

  # NTSync
  boot.kernelModules = [ "ntsync" ];

  environment.systemPackages = with pkgs; [
    mangohud
  ] ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
    heroic
  ];
}
