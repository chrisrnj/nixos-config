{ ... }:

{
  imports = [
    ./configuration.nix
    ./programs
    ./system
  ];

  nixpkgs.overlays = (import ./overlays);
}
