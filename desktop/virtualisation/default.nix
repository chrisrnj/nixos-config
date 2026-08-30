{ lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "initcall_blacklist=sysfb_init"
    "video=efifb:off"
    "pcie_aspm=off"
    "pci=noaer"
    "split_lock_detect=off"
#    "vfio-pci.ids=1002:7550,1002:ab40" - not recommended in Navi 48. Let the amdgpu driver bind the gpu first.
  ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm ignore_msrs=1
    options kvm report_ignored_msrs=0
  '';

  services.hardware.openrgb.enable = lib.mkForce false;

  services.displayManager.plasma-login-manager.enable = lib.mkForce false;
}
