{ config, ... }:

{
  services.openssh.ports = [ 5567 ];

  users.users.christiano.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKWxP8NncQke6U8Kn133dF/7IGq6y4HjfIsUrTUEYKQ christiano@${config.networking.hostName}" ];
}
