{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    amdgpu_top
    btop-rocm
  ];

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
    zluda.enable = true;
  };

  nixpkgs.config.rocmSupport = true;

  environment.variables = {
    MESA_SHADER_CACHE_MAX_SIZE = "16G";
  };
}
