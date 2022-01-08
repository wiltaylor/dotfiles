{pkgs, config, lib, ...}:
with lib;
with builtins;
let

  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = xorg || wayland;

in {
  config = mkIf desktopMode {
    boot.plymouth = {
      enable = true;
      theme = "breeze";
    };

  };

}
