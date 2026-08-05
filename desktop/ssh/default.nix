{ ... }:

{
  services.openssh.ports = [ 6755 ];

  users.users.christiano.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXZ1XC1f1v0s/39S8VyEI742EslYBTf13lLO49TTbCz christiano@Chris" ];

  # Make SSH available on initrd.
  boot.initrd = {
    #availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      ssh.enable = true;
      ssh.hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      ssh.authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABX3WxXQQyjFYRJFc9Kz/OIZIrqYp1r7MEP3wbusmGF root@Chris" ];
    };
  };
}
