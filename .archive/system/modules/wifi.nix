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

{pkgs, lib, config, ...}:
with lib;
let 
  cfg = config.wil.wifi;

in {
  imports = [ ../../.secret/wifi.nix ];

  options.wil.wifi = {
    defaultWifi = mkOption {
      type = types.bool;
      default = true;
      description = "Disable on systems you don't want wifi";
    };
  };

  config = mkIf cfg.defaultWifi {
   networking.wireless.enable = true; 
  };
}
