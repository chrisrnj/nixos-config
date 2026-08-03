# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./system # System related settings.
    ./programs # Packages to install.
  ];

  nixpkgs.overlays = (import ./overlays);

  boot = {
    # Clean Quiet Boot
    plymouth.enable = true;
    consoleLogLevel = 3;
    initrd.verbose = false;
    loader.timeout = 0;

    kernelParams = [
      # Plymouth
      "quiet"
      "splash"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    # ZSwap
    zswap.enable = true;

    # SysRq
    kernel.sysctl."kernel.sysrq" = 1;
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "monthly";
  };

  # Disable emergency mode.
  systemd.enableEmergencyMode = false;

  # Essential system tools, always have them available independent of configuration.
  environment.systemPackages = with pkgs; [
    vim
    kdePackages.kate
    kdePackages.kcalc
    lm_sensors
    vulkan-tools
    clinfo
    libimobiledevice
    gdb
  ];

  # Auto upgrade daily
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--print-build-logs"
      "--recreate-lock-file" #deprecated
      "--cores 8"
      "--max-jobs 4"
    ];
    dates = "weekly";
  };

  # Periodic garbage collection and cleaning old generations
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Optimize /nix/store on every rebuild
  nix.settings.auto-optimise-store = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
