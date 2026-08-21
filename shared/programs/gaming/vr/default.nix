{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wayvr
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
