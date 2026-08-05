{ pkgs, ... }:

{
  boot.kernelParams = [ "drm.edid_firmware=DP-1:edid/sunshine-edid.bin" "video=DP-1:e" ];

  hardware.firmware = [
    (pkgs.runCommand "sunshine-edid" { } ''
      mkdir -p $out/lib/firmware/edid
      cp ${./sunshine-edid.bin} $out/lib/firmware/edid/sunshine-edid.bin
    '')
  ];
}
