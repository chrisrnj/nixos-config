{ ... }:

{
  services.pipewire = {
    wireplumber.extraConfig = {
      "bluez-config" = {
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
