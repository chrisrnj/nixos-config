{ ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    extraConfig = ''
      Host github.com
        IdentityFile /home/christiano/.ssh/github
        IdentitiesOnly yes
    '';
  };

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
}
