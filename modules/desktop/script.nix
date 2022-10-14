{pkgs, config, lib, ...}:
with pkgs;
with lib;
let 
    cfg = config.sys;
in {
  config = {
    sys.script.desktop = [
    {
        name = "wallpaper";
        action = ''
            if [[ "$XDG_SESSION" -eq "wayland" ]]; then
              killall swaybg
              ${pkgs.swaybg}/bin/swaybg -i $(find ~/.config/wallpapers/. -type f| shuf -n1) &
            else 
              ${pkgs.feh}/bin/feh --bg-fill --randomize ~/.config/wallpapers/*
            fi
            '';
        shortHelp = "Randomly selects a new wallpaper.";
        longHelp = "Randomly selects a new wallpaper.";
    }
    {
        name = "screenshot";
        action = ''
            if [[ "$XDG_SESSION" -eq "wayland" ]]; then
              ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" -o /tmp/screenshot.png - | wl-copy
            else
              maim -s --format png | xclip -selection clipboard -t image/png -i
            fi
            '';
        shortHelp = "Takes a screenshot.";
        longHelp = "Takes a screenshot.";
    }
    {
        name = "lock";
        action = ''
            if [[ "$XDG_SESSION" -eq "wayland" ]]; then
              swaylock -c '#000000'
            else
              i3lock
            fi
            '';
        shortHelp = "Locks the computer.";
        longHelp = "Locks the computer.";
    }
    {
        name = "volup";
        action = ''
            SINK=$(pactl list short| grep RUNNING | awk '{print $1}')
            VOL=$(pactl list sinks | grep '^[[:space:]]Volume:' | awk '{print substr($5, 1, length($5)-1)}')

            if [[ $VOL -gt 0 ]]; then
              VSTR="+5%"
            else
              VSTR="5%"
            fi

            if [ $((VOL + 5)) -gt 100 ]; then
              VSTR="100%"
            fi

            if [ $((VOL + 5)) -lt 0 ]; then
              VSTR="0%"
            fi

            ${pkgs.pulseaudio}/bin/pactl set-sink-volume $SINK $VSTR
        '';
        shortHelp = "Increments the volume up.";
        longHelp = "Increments the volume up.";
    }
    {
        name = "voldown";
        action = ''
            SINK=$(pactl list short| grep RUNNING | awk '{print $1}')
            VOL=$(pactl list sinks | grep '^[[:space:]]Volume:' | awk '{print substr($5, 1, length($5)-1)}')

            if [[ $VOL -gt 0 ]]; then
              VSTR="+5%"
            else
              VSTR="5%"
            fi

            if [ $((VOL - 5)) -gt 100 ]; then
              VSTR="100%"
            fi

            if [ $((VOL - 5)) -lt 0 ]; then
              VSTR="0%"
            fi

            ${pkgs.pulseaudio}/bin/pactl set-sink-volume $SINK $VSTR
        
        '';
        shortHelp = "Decrements the volume down.";
        longHelp = "Decrements the volume down.";
    }
    {
        name = "volmute";
        action = ''
            SINK=$(pactl list short| grep RUNNING | awk '{print $1}')
            VOL=$(pactl list sinks | grep '^[[:space:]]Volume:' | awk '{print substr($5, 1, length($5)-1)}')        

            ${pkgs.pulseaudio}/bin/pactl set-sink-mute $SINK toggle
        '';
        shortHelp = "Mutes the volume.";
        longHelp = "Mutes the volume.";
    }
    {
        name = "vol";
        action = ''
            SINK=$(pactl list short| grep RUNNING | awk '{print $1}')
            VOL=$(pactl list sinks | grep '^[[:space:]]Volume:' | awk '{print substr($5, 1, length($5)-1)}')

            echo $VOL
        '';
        shortHelp = "Prints the current volume.";
        longHelp = "Prints the current volume.";
    }
    {
        name = "cputemp";
        action = ''
            ${config.sys.cpu.sensorCommand}
        '';
        shortHelp = "Prints the cpu temp.";
        longHelp = "Prints the cpu temp.";
    }
    {
        name = "gputemp";
        action = ''
            ${config.sys.hardware.graphics.gpuSensorCommand}
        '';
        shortHelp = "Prints the gpu temp.";
        longHelp = "Prints the gpu temp.";
    }
  ];
  };
}
