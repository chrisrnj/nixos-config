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
      ./gaming # Gaming settings.
      ./sunshine # Sunshine configuration.
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Productivity
    gimp-with-plugins
    tenacity

    # Development
    jetbrains.idea
    android-tools
    maven
    msedit
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
    stremio-linux-shell
  ] ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
    davinci-resolve
    dropbox
    unityhub
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

