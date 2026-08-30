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
      openASAR.enable = false;
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
      plugins = {
        alwaysAnimate.enable = true;
        alwaysExpandRoles.enable = true;
        anonymiseFileNames.enable = true;
        biggerStreamPreview.enable = true;
        disableCallIdle.enable = true;
        clearUrls.enable = true;
#         fakeNitro.enable = true;
        fixImagesQuality.enable = true;
        gameActivityToggle.enable = true;
        imageZoom.enable = true;
        messageLogger.enable = true;
        noReplyMention.enable = true;
        oneko.enable = true;
        onePingPerDm.enable = true;
        platformIndicators = {
          enable = true;
          list = false;
          messages = false;
        };
        quickMention.enable = true;
        relationshipNotifier.enable = true;
        voiceMessages.enable = true;
        crashHandler.enable = true;
        messageLatency.enable = true;
        gifPaste.enable = true;
      };
    };
  };
}
