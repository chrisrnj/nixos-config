{ pkgs, ... }:

{
  programs.moonlight-qt = {
    enable = true;
    capSysNice = true;
  };

  # Captive portal login browser.
  programs.captive-browser = {
    enable = true;
    interface = "wlan0";
  };
}
