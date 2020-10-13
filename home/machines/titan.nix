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
}
