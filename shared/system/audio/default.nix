{ ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.extraConfig = {
      "bluez-config" = {
        "wireplumber.settings" = {
          ## Whether to use headset profile in the presence of an input stream.
          "bluetooth.autoswitch-to-headset-profile" = "false";
        };
        "monitor.bluez.properties" = {
          # Severe stuttering with SBC-XQ, disable it altogether:
          "bluez5.enable-sbc-xq" = "false";
          "bluez5.enable-msbc" = "false";
          "bluez5.codecs" = [ "aac" ];
          "bluez5.roles" = [ "a2dp_sink" "a2dp_source"];
        };
      };
    };
  };
}
