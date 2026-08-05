{ pkgs, ... }:

{
#   environment.systemPackages = with pkgs; [
#   ];

  programs.moonlight-qt = {
    enable = true;
    capSysNice = true;
  };
}
