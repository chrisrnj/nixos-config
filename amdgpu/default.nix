{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop-rocm
    libva-utils
  ];

  hardware = {
    # ROCM OpenCL
    amdgpu.opencl.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
#       extraPackages = with pkgs; [
#         libvdpau-va-gl
#       ];
    };
  };

  nixpkgs.config.rocmSupport = true;

  environment.variables = {
    MESA_SHADER_CACHE_MAX_SIZE = "16G";
#    AMD_VULKAN_ICD = "RADV";
#    VDPAU_DRIVER = "va_gl";
  };
}
