{config, pkgs, lib, ...}:
{
  environment.systemPackages = with pkgs; [
    appimage-run
    dfeet
    gnome3.zenity
    ueberzug

    (pkgs.writeScriptBin "desktop" ''
      #!${pkgs.bash}/bin/bash

      case $1 in
      "wallpaper")
        ${pkgs.feh}/bin/feh --bg-fill --randomize ~/.config/wallpapers/*
      ;;
      "winman")
        ${xlibs.xprop}/bin/xprop -root -notype | grep "_NET_WM_NAME =" | cut -d '"' -f2
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

    '')
  ];

  services.gnome.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;
  environment.pathsToLink = [ "/share/accountsservice" ];
}
