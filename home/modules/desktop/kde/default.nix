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
  cfg = config.wil.kde;
in {
  options.wil.kde = {
    enable = mkEnableOption "Enable kde configurations";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      breeze-qt5
    ];

    home.file = {
      ".kde4/share/config/kdeglobals".source = ./kdeglobals;
      ".kde4/share/apps/color-schemes/Breeze.colors".source = ./Breeze.colors;
      ".kde4/share/apps/color-schemes/BreezeDark.colors".source = ./BreezeDark.colors;
    };
  };
}
