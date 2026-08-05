{ ... }:

{
  imports = [
    ./audio # Audio settings.
    ./core-components # General services like printing, bluetooth, etc.
    ./networking # Network settings.
    ./user-customization # Settings like timezone, display manager, keyboard layout, etc.
    ./virtualisation
  ];
}
