{ lib, ... }:

{
  services.pipewire.extraConfig.pipewire = {
    "10-null-sink" = {
      "context.objects" = lib.singleton {
        factory = "adapter";
        args = {
          "factory.name" = "support.null-audio-sink";
          "node.name" = "audiorelay-virtual-mic-sink";
          "node.description" = "Virtual Mic Sink";
          "media.class" = "Audio/Sink";
          "audio.position" = "FL,FR";
          "node.passive" = true;
        };
      };
    };
    "20-virtual-mic" = {
      "context.modules" = lib.singleton {
        name = "libpipewire-module-loopback";
        args = {
          "capture.props" = {
            "node.target" = "audiorelay-virtual-mic-sink";
          };
          "playback.props" = {
            "node.name" = "audiorelay-virtual-mic";
            "node.description" = "Virtual Mic";
            "media.class" = "Audio/Source";
            "audio.position" = "FL,FR";
            "node.passive" = true;
          };
        };
      };
    };
  };
}
