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
  cfg = config.wil.nixos;
in {
    
  options.wil.nixos = {
    disableGC = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable to turn off gc options. You should leave by default.
      '';
    };
  };

  config = {
    system.stateVersion = "20.09";

    nix.gc = mkIf (cfg.disableGC == false)  {
      automatic = true;
      options = "--delete-older-than 5d";
    };

    nix.package = pkgs.nixUnstable;
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    i18n.defaultLocale = "en_AU.UTF-8";
    time.timeZone = "Australia/Brisbane";


    # Core OS built in packages
    environment.systemPackages = with pkgs; [
      wget
      curl
      bind
      killall
      dmidecode
    ];
  };
}
