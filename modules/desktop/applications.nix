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
      xonotic
      quakespasm
      superTuxKart
      openmw
      wpsoffice
      onlyoffice-bin
      libreoffice
      obsidian
      steam
      protonup
      jetbrains.goland
      jetbrains.pycharm-professional
      jetbrains.rider
      jetbrains.jdk
      jetbrains.clion
      jetbrains.datagrip
      jetbrains.ruby-mine
      jetbrains.idea-ultimate
      go
      rustup
      clang
      gcc
      ruby
      python3Full
      dotnet-sdk
      dotnet-runtime
      mono
    ];
  };
}
