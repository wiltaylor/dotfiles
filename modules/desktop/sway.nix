{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = wayland;
in {

  config = mkIf desktopMode {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        waybar
        wofi
      ];
    };
  };
}
