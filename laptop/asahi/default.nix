{ lib, ... }:

{
  hardware.asahi = {
    enable = true;
    # Video Acceleration.
    avd.vaapi-support = true;
    peripheralFirmwareDirectory = lib.findFirst (path: builtins.pathExists (path + "/firmware.cpio")) null [
      /boot/vendorfw
      /mnt/boot/vendorfw
      /etc/nixos/laptop/asahi/firmware
    ];
  };

  # Use systemd-boot.
  boot.loader.systemd-boot.enable = true;
}
