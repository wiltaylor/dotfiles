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

{ pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.wil.gpg;
in {
  
  options.wil.gpg = {
    enable = mkEnableOption "Enable user GPG services";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      pinentry-gtk2
    ];

    home.file = {
      ".ssh/authorized_keys".source = ./authorized_keys;
      ".gnupg/gpg-agent.conf".source = ./gpg-agent.conf;
      ".gnupg/gpg.confg".source = ./gpg.conf;
      ".gnupg/public.key".source = ./public.key;
    };
  };
}
