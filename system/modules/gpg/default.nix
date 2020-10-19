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
    environment.systemPackages = with pkgs; [
      pinentry-gtk2
    ];

    system.activationScripts = { 
      setup-gpg = ''
        mkdir -p $out/home/wil/.gnupg
        ln -sf ${./authorized_keys} /home/wil/.gnupg/authorized_keys
        ln -sf ${./gpg-agent.conf} /home/wil/.gnupg/gpg-agent.conf
        ln -sf ${./gpg.conf} /home/wil/.gnupg/gpg.conf
        ln -sf ${./public.key} /home/wil/.gnupg/public.key
      '';
    };
  };
}
