{config, pkgs, lib, ...}:
with lib;
with builtins;
let
  desktopMode = (length config.sys.graphics.desktopProtocols) > 0;

  desktopScript = pkgs.writeScriptBin "desktop" ''
      #!${pkgs.bash}/bin/bash

      case $1 in
      "wallpaper")
        ${pkgs.feh}/bin/feh --bg-fill --randomize ~/.config/wallpapers/*
      ;;
      "winman")
        ${pkgs.xlibs.xprop}/bin/xprop -root -notype | grep "_NET_WM_NAME =" | cut -d '"' -f2
      ;;
      "about")
        ${pkgs.gnome3.zenity}/bin/zenity --about
      ;;
      *)
        echo "Usage:"
        echo "desktop command"
        echo ""
        echo "Commands:"
        echo "wallpaper - randomly selects new wallpapers"
        echo "winman - Prints the current window manager"
      ;;
      esac

    '';
in {
  environment.systemPackages = with pkgs; [
    (mkIf desktopMode desktopScript)
  ];

}
