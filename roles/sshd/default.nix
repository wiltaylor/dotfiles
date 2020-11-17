{config, pkgs, lib, ...}:
{
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
}
