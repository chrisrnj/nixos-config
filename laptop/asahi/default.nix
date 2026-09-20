{ ... }:

{
  hardware.asahi = {
    enable = true;
    # Video Acceleration.
    avd.vaapi-support = true;
  };

  # Use systemd-boot.
  boot.loader.systemd-boot.enable = true;
}
