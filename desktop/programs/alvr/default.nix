{ lib, pkgs, ... }:

{
  programs.alvr = {
    enable = true;
    openFirewall = true;
    package =
    let
      alvrSrc = pkgs.fetchFromGitHub {
        owner = "alvr-org";
        repo = "ALVR";
        rev = "6b75f2f118b3ce71c55d1b0c863414a24322e28a";
        fetchSubmodules = true;
        hash = "sha256-KxH6te85VWs8bHmcPtqbM9pydXNmsoQV4eomW4YTLjg=";
      };
    in
    (pkgs.alvr.override {
      ffmpeg-alvr = pkgs.ffmpeg_8;
    }).overrideAttrs (old: {
      version = "21.0.0-dev12";
      src = alvrSrc;

      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        src = alvrSrc;
        hash = "sha256-61x5txV+5j7k1+/6kPaEncWDAcyfERRjFb5ZoLhtUG4=";
        # add these only if the original derivation used them too
        # name = "alvr-21.0.0-dev12";
      };

      patches = [
        (pkgs.replaceVars ./fix-finding-libs.patch {
          vulkan-headers = lib.getInclude pkgs.vulkan-headers;
          ffmpeg = lib.getDev pkgs.ffmpeg_8;
          x264 = lib.getDev pkgs.x264;
        })
      ];
    });
  };
}
