{ inputs, pkgs, lib, ... }:

{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") (
    let
      patchedBwrap = pkgs.bubblewrap.overrideAttrs (o: {
        patches = (o.patches or []) ++ [
          ./bwrap.patch
        ];
      });

      proton-ge-bin = pkgs.proton-ge-bin;
      protonCachyPkgs = inputs.proton-cachyos.packages.${pkgs.stdenv.hostPlatform.system} or {};
      proton-cachyos = protonCachyPkgs.proton-cachyos-x86_64_v3 or null;
    in {
      # Steam
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          buildFHSEnv = (args: ((pkgs.buildFHSEnv.override {
            bubblewrap = patchedBwrap;
          }) (args // {
            extraBwrapArgs = (args.extraBwrapArgs or []) ++ [ "--cap-add ALL" ];
          })));
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
        ] ++ lib.optionals (proton-cachyos != null) [
          proton-cachyos
        ];
      };

      # Make Steam use patched bwrap.
      system.userActivationScripts.steamUsePatchedBwrap.text = ''
        mkdir -p $HOME/.local/share/Steam/ubuntu12_32/steam-runtime/usr/libexec/steam-runtime-tools-0
        ln -sfn ${patchedBwrap}/bin/bwrap $HOME/.local/share/Steam/ubuntu12_32/steam-runtime/usr/libexec/steam-runtime-tools-0/srt-bwrap
        '';

      # Create symlink of proton-cachyos for use in other programs such as bs-manager.
      system.userActivationScripts.protonLink.text = lib.mkIf (proton-cachyos != null) ''
        mkdir -p $HOME/.local/share
        ln -sfn ${proton-cachyos.steamcompattool} $HOME/.local/share/proton
        '';

      # WiVRn
      services.wivrn = {
        enable = true;
        openFirewall = true;
        autoStart = true;
        highPriority = true;
        steam.importOXRRuntimes = true;
        package = pkgs.wivrn;
      };

      environment.systemPackages = with pkgs; [
        bs-manager
        wayvr
      ];
  });
}
