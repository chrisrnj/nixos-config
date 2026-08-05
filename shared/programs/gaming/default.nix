{ lib, pkgs, ... }:

{
  imports = [
    ./prismlauncher.nix
    ./steam
  ];

  # Gamemode
  programs.gamemode.enable = true;

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
