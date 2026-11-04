{ pkgs, ... }:

{
  imports = [
    ./sunshine
  ];

  services.wivrn.autoStart = true;
}
