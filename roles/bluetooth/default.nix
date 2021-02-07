{ pkgs, config, lib, ... }:
{
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  services.blueman.enable = true;
}
