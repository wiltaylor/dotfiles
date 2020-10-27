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
  cfg = config.wil.alacritty;
in {
  options.wil.alacritty = {
    enable = mkEnableOption "Enable Alacritty terminal";
  };

  config = mkIf(cfg.enable) {

    home.sessionVariables = {
      TERMINAL = "${pkgs.alacritty}/bin/alacritty";
    };
    
    home.packages = with pkgs; [
      alacritty
    ];

    home.file = {
      ".config/alacritty/alacritty.yml".source = ./alacritty.yml;
    };
  };
}
