{pkgs, config, lib, ...}:
with lib;
with builtins;
let

  xorg = (elem "xorg" config.sys.hardware.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.hardware.graphics.desktopProtocols);
  desktopMode = xorg || wayland;

in {
  config = mkIf desktopMode {
    boot.initrd.systemd.enable = true; # This is needed to show the plymouth login screen to unlock luks
    boot.plymouth = {
      enable = true;
      theme = "breeze";
    };

  };

}
