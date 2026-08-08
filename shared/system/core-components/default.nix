{ config, pkgs, ... }:

{
  # Enable sched-ext.
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };

  # Enable uinput.
  hardware.uinput.enable = true;

  # Ensure NTP is enabled to sync time automatically via the internet
  services.ntp.enable = true;

  # Enable FW updates.
  services.fwupd.enable = true;

  # Enable i2c
  hardware.i2c.enable = true;

  # Enable support for Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
#     settings = {
#       General = {
#         ControllerMode = "bredr";
#         Experimental = false;
#       };
#     };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
