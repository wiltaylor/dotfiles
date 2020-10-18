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

{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.wil.users;
in {
  options.wil.users = {
    default = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Set to false to prevent creation of default wil user accoun.
      '';
    };

    disableSudoTimeout = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Set to only prompt user with sudo password on the first time.
      '';
    };

    enableOhMyZsh = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable ohmyzsh at the system level.
      '';
    };
  };

  config = mkIf(cfg.default) {
    
    programs.zsh.enable = true;
    programs.zsh.ohMyZsh.enable = cfg.enableOhMyZsh;

    users.users.wil= {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ]; 
      uid = 1000;
      shell = pkgs.zsh; 
    };

    security.sudo.extraConfig = mkIf cfg.disableSudoTimeout ("Defaults env_reset,timestamp_timeout=-1");
  };
}
