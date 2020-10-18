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


{ config, pkgs, lib, ... }:
{

  imports = [
    ../modules
  ];

  wil.gpg.enable = true;
  wil.nvim.enable = true;
  wil.spotify.enable = true;
  wil.zsh.enable = true;
  wil.tmux.enable = true;
  wil.git.enable = true;
  wil.syncthing.enable = true;
  wil.desktop.enable = true;
  wil.vscode.enable = true;
  wil.cli.enable = true;
  wil.ranger.enable = true;
  wil.mail.enable = true;
  wil.appimage.enable = true;
  wil.pass.enable = true;
  wil.virtman.enable = true;
  wil.gitkraken.enable = true;
  wil.youtube.enable = true;
  wil.games.enable = true;
}
