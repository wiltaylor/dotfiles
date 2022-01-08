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
      # extraOptions = [ "--debug" ]; # Use this option to send sway logs to journalctl 
      extraPackages = with pkgs; [
        waybar
        swaybg
        wofi
        imv
      ];
    };
  };
}
