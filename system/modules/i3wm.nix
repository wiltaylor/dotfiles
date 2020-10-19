# This config is mainly used for the install iso.
# My actual install normally uses i3wm from home manager.
{pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.wil.i3wm;
in {

  options.wil.i3wm = {
    enable = mkEnableOption "Enable i3wm and not allow it to be controlled by home manager.";
  };

  config = mkIf (cfg.enable) {
    services.xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = true;
      };

      displayManager = {
        defaultSession = "none+i3";
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
      };
    };
  };
}
