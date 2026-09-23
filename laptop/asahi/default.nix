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

  # Use systemd-boot.
  boot.loader.systemd-boot.enable = true;
}
