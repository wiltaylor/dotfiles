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
  cfg = config.wil.yubikey;

in {
  options.wil.yubikey = {
    enable = mkEnableOption "Enable yubikey hardware services";
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      gnupg
      yubikey-personalization
      yubioath-desktop
    ];

    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
  };
}
