{ inputs, lib, pkgs, ... }:

{
  imports = [ inputs.nixcord.nixosModules.nixcord ];

  programs.nixcord = {
    enable = true;
    user = "christiano"; # Needed for system-level config
    discord = {
      enable = if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then true else false;
      vencord.enable = true;
      krisp.enable = true;
      openASAR.enable = true;
      commandLineArgs = [
        "--enable-blink-features=MiddleClickAutoscroll"
        "--force-device-scale-factor"
      ];
    };
    vesktop = lib.mkIf (pkgs.stdenv.hostPlatform.system == "aarch64-linux") {
      enable = true;
      autoscroll.enable = true;
    };
    config = {
      autoUpdate = true;
      autoUpdateNotification = true;
      frameless = true;
      transparent = true;
      plugins = {
        clearUrls.enable = true;
#         fakeNitro.enable = true;
        fixImagesQuality.enable = true;
        gameActivityToggle.enable = true;
        crashHandler.enable = true;
        messageLatency.enable = true;
        gifPaste.enable = true;
      };
    };
  };
}
