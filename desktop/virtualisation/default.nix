{ lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "amdgpu"
  ];

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "initcall_blacklist=sysfb_init"
    "video=efifb:off"
    "pcie_aspm=off"
    "pci=noaer"
    "split_lock_detect=off"
#    "vfio-pci.ids=1002:7550,1002:ab40"
  ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm ignore_msrs=1
    options kvm report_ignored_msrs=0
  '';

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  services.hardware.openrgb.enable = lib.mkForce false;

  services.displayManager.autoLogin.enable = lib.mkForce false;
}
