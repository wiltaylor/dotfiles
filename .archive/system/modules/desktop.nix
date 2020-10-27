# __          ___ _   _______          _
# \ \        / (_) | |__   __|        | |
#  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
#   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
#    \  /\  /  | | |    | | (_| | |_| | | (_) | |
#     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
#                                 __/ |
#                                |___/
# Web: https://wil.dev
# Github: https://github.com/wiltaylor
# Contact: web@wiltaylor.dev
# Feel free to use this configuration as you wish.

{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.desktop;
in {

  options.wil.desktop = {
    x11 = { 
      enable = mkEnableOption "Enable user desktop environments in xorg";
      drivers = mkOption {
        type = types.listOf types.string;
        default = [];
        description = "List of video drivers to use";
      };
    };
    
    #TODO: Add wayland stuff for intel based laptops
  };

  config = mkIf (cfg.x11.enable) {
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    services.xserver = {
      enable = true;

      videoDrivers = cfg.x11.drivers;
      
      displayManager.lightdm.enable = true;
      displayManager.session = [
        {
          manage = "desktop";
          name = "xsession";
          start = "exec $HOME/.xsession";
        }
      ];

      displayManager.defaultSession = "xsession";
      displayManager.job.logToJournal = true;
      libinput.enable = true;
    };
  };
}
