{ pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "br";

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christiano = {
    isNormalUser = true;
    description = "Christiano";
    extraGroups = [
      "adbusers" # adb
      "i2c"
      "wheel"
    ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Fonts.
#   fonts.packages = with pkgs; [
#     ubuntu-sans
#     inter
#     inter-nerdfont
#     google-fonts
#     roboto
#   ];

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  environment.sessionVariables = {
    KWIN_WAYLAND_SUPPORT_XX_PIP_V1 = "1"; # Experimental wayland pip protocol.
    NIXOS_OZONE_WL = "1"; # Use ozone wayland.
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;
  xdg.portal.config.common.default = [ "kde" "gtk" ];

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "christiano";
}
