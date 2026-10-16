{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wayvr
  ] ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
    bs-manager
  ];

  # WiVRn
  services.wivrn = {
    enable = true;
    openFirewall = true;
    highPriority = true;
    steam = {
      enable = config.programs.steam.enable;
      importOXRRuntimes = true;
    };
  };
}
