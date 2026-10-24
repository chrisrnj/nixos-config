{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false; # Lanzaboote

    # Enable Secure Boot with Lanzaboote
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
