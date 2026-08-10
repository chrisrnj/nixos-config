{ pkgs, inputs, lib, ... }:

{
  imports =
    [
#       ./audiorelay # AudioRelay virtual mic sink.
      ./chromium # Ungoogled chromium install and policies for chromium-based browsers.
      ./discord
      ./gaming # Gaming settings.
      ./java
#       ./nix-ld # Run arbitrary programs.
      ./obs # OBS and plugins.
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Productivity
    gimp-with-plugins
    libreoffice-qt
    hunspell
    hunspellDicts.pt_BR
    hunspellDicts.en_US
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
    python3

    # Tools
    qbittorrent
    unrar
    mpv
    handbrake
    ffmpeg
    filezilla
    yt-dlp
#     inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default
    proton-vpn
    stremio-linux-shell
  ]
  # These currently only have support for x86_64-linux, but it would be nice to have them working on both systems.
  ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
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
}

