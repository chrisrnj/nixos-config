{ pkgs, inputs, lib, ... }:

{
  imports =
    [
#       ./audiorelay # AudioRelay virtual mic sink.
      ./chromium # Ungoogled chromium install and policies for chromium-based browsers.
      ./discord
      ./java
#       ./nix-ld # Run arbitrary programs.
      ./obs # OBS and plugins.
      ./prismlauncher
      ./steam # Steam installation settings.
      ./sunshine # Sunshine configuration.
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Productivity
    gimp-with-plugins
    tenacity
    davinci-resolve

    # Development
    jetbrains.idea
    android-tools
    maven
    msedit
    unityhub
    vscode.fhs
    dotnet-sdk
    gnumake
    gcc
    gradle_9
    gradle-completion

    # Tools
    qbittorrent
    unrar
    mpv
    handbrake
    ffmpeg
    yt-dlp
#     inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default
    proton-vpn

    # Games
    bs-manager
    mangohud
    heroic
    wayvr

    # Internet
    dropbox
    stremio-linux-shell
  ];

  # Firefox
  programs.firefox.enable = true;

  # KDE Connect
#   programs.kdeconnect.enable = true;

  # Git
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Tailscale
  services.tailscale.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # KDE Partition manager
  programs.partition-manager.enable = true;

  # Waydroid
  virtualisation.waydroid.enable = true;

  # OpenRGB
  services.hardware.openrgb.enable = true;
}

