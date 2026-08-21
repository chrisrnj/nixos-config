# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
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
    kdePackages.skanpage
    lm_sensors
    vulkan-tools
    clinfo
    libimobiledevice
    pciutils
    usbutils
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
}
