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

  environment.sessionVariables = {
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
  };

  environment.systemPackages = with pkgs; [
      pavucontrol
      pkgs.xorg.xmodmap
      maim
      xclip
      pkgs.xorg.xev
      feh
      foot
      libsixel
      yed

      dfeet
      pcmanfm
      neovimWT
      emacs-custom
      emacs-sqlite
      gnuplot
      mupdf
      pkgs.xorg.xhost

      mpv
      blender
      gimp
      youtube-dl
      obs-studio
      kdenlive
      tenacity
      ardour
      firefox
      chromium
      wpsoffice
      onlyoffice-bin
      libreoffice
      obsidian
      distrobox
      virtmanager
    ];
  };
}
