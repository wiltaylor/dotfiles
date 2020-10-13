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
  cfg = config.wil.pass;
in {
  options.wil.pass = {
    enable = mkEnableOption "Unix password manager";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      pass-otp
    ];
  };
}
