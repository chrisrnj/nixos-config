{ config, lib, pkgs, ... }:

{
  users.users.christiano.extraGroups = [ "libvirtd" ];

  programs.virt-manager.enable = true;

  services.spice-vdagentd.enable = true;

  virtualisation = {
    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        verbatimConfig = ''
          user = "christiano"
          group = "users"
        '';
      };
    };

    containers.storage.settings.storage.driver = "btrfs";

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };

    docker.storageDriver = "btrfs";
  };

  environment.systemPackages = with pkgs; [
    dnsmasq
    swtpm
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
