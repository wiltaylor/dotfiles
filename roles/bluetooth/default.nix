{ pkgs, config, lib, ... }:
{
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
}
