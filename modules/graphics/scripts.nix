{config, pkgs, lib, ...}:
with lib;
with builtins;
let
  desktopMode = (length config.sys.graphics.desktopProtocols) > 0;

  desktopScript = pkgs.writeScriptBin "desktop" ''
      #!${pkgs.bash}/bin/bash

      case $1 in
      "wallpaper")

        if [[ "$XDG_SESSION" -eq "wayland" ]]; then
          killall swaybg
          ${pkgs.swaybg}/bin/swaybg -i $(find ~/.config/wallpapers/. -type f| shuf -n1) &
        else 
          ${pkgs.feh}/bin/feh --bg-fill --randomize ~/.config/wallpapers/*
        fi
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
