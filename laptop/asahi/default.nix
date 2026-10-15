{ lib, ... }:

{
  hardware.asahi = {
    enable = true;
    # Video Acceleration.
    avd.vaapi-support = true;
    peripheralFirmwareDirectory = lib.findFirst (path: builtins.pathExists (path + "/firmware.cpio")) null [
      /etc/nixos/laptop/asahi/firmware
      /boot/vendorfw
      /mnt/boot/vendorfw
    ];
  };

  nix.settings = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };

  # Use systemd-boot.
  boot.loader.systemd-boot.enable = true;
}
