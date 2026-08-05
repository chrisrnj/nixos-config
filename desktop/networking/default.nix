{ ... }:

{
  networking.interfaces.enp7s0 = {
    mtu = 1480;
    wakeOnLan.enable = true;
  };
}
