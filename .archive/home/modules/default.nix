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


{pkgs, ... }:
{

  # Base config which is applied to all systems
  config = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = import ./pkgs;

    systemd.user.startServices = true;
    home.stateVersion = "20.09";
    services.lorri.enable = true;

    home.username = "wil";
    home.homeDirectory = "/home/wil";

    home.packages = with pkgs;[
      direnv
    ];
  };

  imports = [
    ./gpg
    ./nvim
  #  ./spotify
    ./zsh
    ./tmux
    ./git
    ./syncthing
    ./desktop
    ./cli
    ./ranger
    ./pass
    ./mail
    ./appimage
    ./games
  ];
}
