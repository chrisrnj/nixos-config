{ config, lib, pkgs, ... }:

{
  # Network settings
  networking = {
    networkmanager = {
      enable = true; # Enable networking
      dns = "none";
    };

    # Cloudflare DNS
    nameservers = [ "2606:4700:4700::1111" "2606:4700:4700::1001" "1.1.1.1" "1.0.0.1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";

    nftables.enable = true;

    interfaces.enp7s0 = {
      mtu = 1480;
      # Wake on LAN
      wakeOnLan.enable = true;
    };
  };

# Generate an immutable /etc/resolv.conf from the nameserver settings
# above (otherwise DHCP overwrites it):
#   environment.etc."resolv.conf" = with lib; with pkgs; {
#     source = writeText "resolv.conf" ''
#       ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
#       options edns0
#     '';
#   };
}
