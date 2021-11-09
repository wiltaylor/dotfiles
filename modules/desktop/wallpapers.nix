{pkgs, lib, config, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = xorg || wayland;
in {
  config = mkIf desktopMode {
    sys.users.allUsers.files = {
      wallpapers = {
        path = ".config/wallpapers";
        source = ../../wallpapers;
      };
    };
  };
}
