{ inputs, pkgs, lib, ... }:

{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") ({
      # Steam
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            PROTON_ENABLE_WAYLAND = "1";
            PROTON_USE_PIPEWIRE = "1";
            PROTON_FSR4_UPGRADE = "1";
            PROTON_DXVK_LOWLATENCY = "1";
            PROTON_DISCORD_BRIDGE = "1";
            LOW_LATENCY_LAYER = "1";
            VKD3D_CONFIG = "descriptor_heap";
            MANGOHUD = "1";
          };
        };
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        extest.enable = true;
        #protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          dwproton-bin
          proton-cachyos_x86_64_v3
          proton-ge-bin
        ];
      };

      # Create symlink of proton for use in other programs such as bs-manager.
      system.userActivationScripts.protonLink.text = ''
        mkdir -p $HOME/.local/share
        ln -sfn ${pkgs.dwproton-bin.steamcompattool} $HOME/.local/share/proton
        '';

      environment.systemPackages = with pkgs; [
        bs-manager
      ];
  });
}
