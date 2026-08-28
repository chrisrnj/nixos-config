{ pkgs, ... }:

{
#   environment.systemPackages = with pkgs; [
#   ];

  programs.moonlight-qt = {
    enable = true;
    capSysNice = true;
#     package = pkgs.moonlight-qt.overrideAttrs {
#       src = pkgs.fetchFromGitHub {
#         owner = "moonlight-stream";
#         repo = "moonlight-qt";
#         rev = "2e13ed9977bc31c73caf8428f08f58d793313ece";
#         hash = "sha256-kCm/YoFGcXhF/Abi5lRV5F7H1AbKJchdDOlfBVR0tRA=";
#         fetchSubmodules = true;
#       };
#       patches = [];
#     };
  };

  # Captive portal login browser.
  programs.captive-browser = {
    enable = true;
    interface = "wlan0";
  };
}
