{config, pkgs, lib, ...}:
with lib;
with builtins;
let
  desktopMode = (length config.sys.graphics.desktopProtocols) > 0;

  desktopScript = pkgs.writeScriptBin "desktop" ''
      #!${pkgs.bash}/bin/bash

      adjustvol() {
        SINK=$(pactl list short| grep RUNNING | awk '{print $1}')

        ${pkgs.pulseaudio}/bin/pactl set-sink-volume $SINK $1
      }

      mutevol() {
        SINK=$(pactl list short| grep RUNNING | awk '{print $1}')

        ${pkgs.pulseaudio}/bin/pactl set-sink-mute $SINK toggle
      }

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
      "screenshot")
        if [[ "$XDG_SESSION" -eq "wayland" ]]; then
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" -o /tmp/screenshot.png - | wl-copy
        else
          maim -s --format png | xclip -selection clipboard -t image/png -i
        fi
      ;;
      "lock")

        if [[ "$XDG_SESSION" -eq "wayland" ]]; then
          swaylock -c '#000000'
        else
          i3lock
        fi
      ;;
      "about")
        ${pkgs.gnome3.zenity}/bin/zenity --about
      ;;
      "volup")
        adjustvol "+5%"
      ;;
      "voldown")
        adjustvol "-5%"
      ;;
      "volmute")
        mutevol
      ;;
      *)
        echo "Usage:"
        echo "desktop command"
        echo ""
        echo "Commands:"
        echo "wallpaper - randomly selects new wallpapers"
        echo "winman - Prints the current window manager"
        echo "screenshot - Takes a screenshot"
        echo "lock - Looks the screen"
        echo "volup - volume up"
        echo "voldown - volume down"
        echo "volmute - toggle mute"
      ;;
      esac

    '';
in {
  environment.systemPackages = with pkgs; [
    (mkIf desktopMode desktopScript)
  ];

}
