{ inputs, pkgs, lib, ... }:

{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") (
    let
      proton-ge-bin = pkgs.proton-ge-bin;
      protonCachyPkgs = inputs.proton-cachyos.packages.${pkgs.stdenv.hostPlatform.system} or {};
      proton-cachyos = protonCachyPkgs.proton-cachyos-x86_64_v3 or null;
    in {
      # Steam
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraPkgs = (pkgs: with pkgs; [
            gamemode
          ]);
          extraEnv = {
            PROTON_ENABLE_WAYLAND = "1";
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
        extraCompatPackages = [
          proton-ge-bin
          dwproton-bin
        ] ++ lib.optionals (proton-cachyos != null) [
          proton-cachyos
        ];
      };

      # Create symlink of proton-cachyos for use in other programs such as bs-manager.
      system.userActivationScripts.protonLink.text = lib.mkIf (proton-cachyos != null) ''
        mkdir -p $HOME/.local/share
        ln -sfn ${proton-cachyos.steamcompattool} $HOME/.local/share/proton
        '';

      environment.systemPackages = with pkgs; [
        bs-manager
      ];
  });
}
