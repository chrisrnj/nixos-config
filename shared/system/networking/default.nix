{ config, lib, pkgs, ... }:

{
  # Network settings
  networking = {
    networkmanager = {
      enable = true; # Enable networking
      wifi = {
        backend = "iwd";
        powersave = true;
      };
    };

    # Cloudflare DNS
    nameservers = [ "2606:4700:4700::1111" "2606:4700:4700::1001" "1.1.1.1" "1.0.0.1" ];

    nftables.enable = true;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      Domains = [ "~." ];
      DNSOverTLS = "true";
      FallbackDNS = config.networking.nameservers;
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
