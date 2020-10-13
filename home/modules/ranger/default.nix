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
  cfg = config.wil.ranger;
in {
  options.wil.ranger = {
    enable = mkEnableOption "Ranger file manager";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      ranger
    ];
    home.file = {
      ".config/ranger/commands_full.py".source = ./commands_full.py;
      ".config/ranger/commands.py".source = ./commands.py;
      ".config/ranger/rc.conf".source = ./rc.conf;
      ".config/ranger/rifle.conf".source = ./rifle.conf;
      ".config/ranger/scope.sh".source = ./scope.sh;
    };
  };
}
