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
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    containers = {
      enable = true;
      storage.settings = {
        storage = {
          driver = "btrfs";
          graphroot = "/var/lib/containers/storage";
          runroot = "/run/containers/storage";
        };
      };
    };

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };

    docker.storageDriver = "btrfs";
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  boot = lib.mkIf config.hardware.cpu.intel.updateMicrocode {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    kernelParams = [
      # Enable IOMMU
      "intel_iommu=on"
      "iommu=pt"
    ];
  };
}
