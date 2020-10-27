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

{pkgs, config, lib, ... }:
with lib;
let
  cfg = config.wil.net;
in {

  options.wil.net = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable or disable network stack";
    };    
  };

  config = mkIf (cfg.enable) {
    networking.networkmanager.enable = true;
    networking.networkmanager.unmanaged = [
      "*" "except:type:wwan" "except:type:gsm"
    ];

    networking.useDHCP = false;

  };
}
