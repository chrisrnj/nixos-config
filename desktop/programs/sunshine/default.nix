{ config, options, pkgs, lib, ... }:

let
  x11-environment = "xcb XAUTHORITY=$(${lib.getExe' pkgs.findutils "find"} /run/user/1000 -maxdepth 1 -name 'xauth_*' | ${lib.getExe' pkgs.coreutils "head"} -n1) DISPLAY=:0";
  kscreen-doctor = "env QT_QPA_PLATFORM=${if config.services.displayManager.defaultSession == "plasmax11" then x11-environment else "wayland"} ${lib.getExe' pkgs.kdePackages.libkscreen "kscreen-doctor"}";
  busctl = "${lib.getExe' pkgs.systemd "busctl"}";
  solar-flare = if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then pkgs.callPackage ./solar-flare.nix {} else null;
in
{
  imports = [
    ./custom-edid
  ];

  networking.firewall = lib.mkIf (config.services.sunshine.package == solar-flare) {
    allowedUDPPorts = [
      48005
      48015
      48016
    ];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    package = if solar-flare != null then solar-flare else pkgs.sunshine;
    settings = {
      address_family = "both";
      locale = "pt_BR";
      # Enable virtual display
      global_prep_cmd = "[{\"do\":\"${kscreen-doctor} output.DP-1.enable output.HDMI${if config.services.displayManager.defaultSession == "plasmax11" then "" else "-A"}-1.disable\",\"undo\":\"${config.systemd.user.services.disableVirtualDisplay.script}\"}]";
      encoder = "vulkan";
      capture = "kms";
      vk_tune = "1";
#       wan_encryption_mode = "0";
    };
    applications = {
      apps = [
        {
          name = "Macbook Air Low-Res";
          prep-cmd = [
            # Set resolution
            {
              do = "${kscreen-doctor} output.DP-1.mode.1440x900@120 output.DP-1.scale.1";
            }
            # Set keyboard
            {
              do = "${busctl} --user call org.kde.keyboard /Layouts org.kde.KeyboardLayouts setLayout u 1";
              undo = "${busctl} --user call org.kde.keyboard /Layouts org.kde.KeyboardLayouts setLayout u 0";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Macbook Air";
          prep-cmd = [
            # Set resolution
            {
              do = "${kscreen-doctor} output.DP-1.mode.2560x1600@120 output.DP-1.scale.1.75";
            }
            # Set keyboard
            {
              do = "${busctl} --user call org.kde.keyboard /Layouts org.kde.KeyboardLayouts setLayout u 1";
              undo = "${busctl} --user call org.kde.keyboard /Layouts org.kde.KeyboardLayouts setLayout u 0";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "TV 768p";
          prep-cmd = [
            # Set resolution
            {
              do = "${kscreen-doctor} output.DP-1.mode.1360x768@120 output.DP-1.scale.1";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "TV 1080p";
          prep-cmd = [
            # Set resolution
            {
              do = "${kscreen-doctor} output.DP-1.mode.1920x1080@120 output.DP-1.scale.1";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "TUBO";
          prep-cmd = [
            # Set resolution
            {
              do = "${kscreen-doctor} output.DP-1.mode.1024x768@85 output.DP-1.scale.1";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "1440p";
          prep-cmd = [
            # Set resolution
            {
              do = "${kscreen-doctor} output.DP-1.mode.2560x1440@120 output.DP-1.scale.1.5";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Resumir";
          exclude-global-prep-cmd = "true";
          auto-detach = "true";
        }
      ];
    };
  };

  # Disables virtual display on boot.
  systemd.user.services.disableVirtualDisplay = {
    description = "Disables virtual display and enables the connected display.";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${kscreen-doctor} output.HDMI${if config.services.displayManager.defaultSession == "plasmax11" then "" else "-A"}-1.enable output.DP-1.disable";
  };
}
