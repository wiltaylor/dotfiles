{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = xorg || wayland;

  emacs-custom = pkgs.writeScriptBin "emacs-run" ''
    ${pkgs.emacs-sqlite}/bin/emacs -q -l ~/.config/emacs/init.el $@
  '';
in {

  config = mkIf desktopMode {
  environment.systemPackages = with pkgs; [
      pavucontrol
      pkgs.xorg.xmodmap
      maim
      xclip
      pkgs.xorg.xev
      feh
      foot
      libsixel

      dfeet
      pcmanfm
      neovimWT
      emacs-custom
      emacs-sqlite
      gnuplot
      gcc
      sqlite
      nyxt
      mupdf
      pkgs.xorg.xhost
      polymc
    ];
  };
}
