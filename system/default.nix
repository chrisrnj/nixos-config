{ ... }:

{
  imports = [
    ./audio.nix # Sound settings.
    ./core-components.nix # General services like printing, bluetooth, etc.
    ./networking.nix # Network settings.
    ./ssh.nix # SSH settings.
    ./user-customization.nix # Settings like timezone, display manager, keyboard layout, etc.
    ./virtualisation.nix
  ];
}
