{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = wayland;
in {

  config = mkIf desktopMode {
    services.sway = {
      enable = true;
    };

    services.xserver.displayManager.session = [
      {
        manage = "desktop";
        name = "i3";
        start = "exec ${pkgs.sway}/bin/sway";
      }
    ];
  };
}
