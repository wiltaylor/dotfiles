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


{pkgs, config, lib, ...}:
{

  imports = [
    ../shared/alacritty
    ../shared/wallpaper.nix
    ../shared/dunst.nix
    ../shared/picom.nix
    ../shared/rofi.nix
    ../shared/applications.nix
  ];

  home.packages = with pkgs; [
    i3blocks-gaps
    my.i3blocks-contrib
    sysstat # Needed for mpstat for i3block
  ];

  home.file.".config/i3/i3blocks.conf".text = ''

    ${if config.machineData.laptop then ''
    [battery2]
    command=${pkgs.my.i3blocks-contrib}/share/i3blocks-contrib/battery2/battery2
    markup=pango
    interval=30
    '' else ""}

    [cpu_usage]
    command=echo " $(grep 'cpu ' /proc/stat | awk '{usage=int(($2+$4)*100/($2+$4+$5))} END {print usage "%"}')"
    interval=5

    [memory_usage]
    command=grep -E 'MemTotal|MemFree' /proc/meminfo | awk '/MemTotal/ {total=int($2/1024)} /MemFree/ {free=int($2/1024)} {used=total-free} END {print " " used "/" total "MB"}'
    interval=5

    [diskspace]
    command=echo " $(df / -H | grep '/' | awk '{print $3 "/" $2}')"
    interval=60

    ${if config.machineData.gpuTempSensor != null then ''
    [gpu_temp]
    command=echo "GPU  $(${config.machineData.gpuTempSensor})"
    interval=5

    '' else ""}

    ${if config.machineData.cpuTempSensor != null then ''
    [gpu_temp]
    command=echo "CPU  $(${config.machineData.cpuTempSensor})"
    interval=5

    '' else ""}

    # Update time every 5 seconds
    [time]
    command=date "+%Y-%m-%d %T"
    interval=5 
    
  '';

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      # Using rec to wipe out default settings
      config = rec {
        modifier = "Mod4";

        startup = [
          {
            command = "${pkgs.autorandr}/bin/autorandr -c";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.xorg.xmodmap}/bin/xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'";
            always = true;
            notification = false;
          }
          {
            command = "systemctl --user restart polybar.service"; 
            always = true; 
            notification = false;
          }
          {
            command = "systemctl --user restart gpg-agent.service";
            always = false;
            notification = false;
          }
          {
            command = "${pkgs.feh}/bin/feh --bg-fill --randomize ~/.config/wallpapers/*";
            always = true;
            notification = false;
          }
        ];

        gaps = {
          inner = 20;
          outer = -4;
        };

        floating = {
          modifier = "${modifier}";
        };

        bars = [
          {
            position = "top";
            statusCommand = "${pkgs.i3blocks-gaps}/bin/i3blocks -c ~/.config/i3/i3blocks.conf";
          }
        ];

      keybindings = {
         "${modifier}+t" = "xinput set-prop 12 \"Device Enabled\" 0";
         "${modifier}+shift+t" = "xinput set-prop 12 \"Device Enabled\" 1";
         "${modifier}+m" = "exec ${pkgs.alacritty}/bin/alacritty -e mail";
         "${modifier}+Shift+m" = "exec kill-mail";
         "${modifier}+Shift+r" = "restart";
 	       "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
         "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
         "${modifier}+w" = "exec MOZ_USE_XINPUT2=1 ${pkgs.firefox}/bin/firefox";
         "${modifier}+Shift+q" = "kill";
         "${modifier}+Left" = "focus left";
         "${modifier}+Right" = "focus right";
         "${modifier}+Up" = "focus up";
         "${modifier}+Down" = "focus down";
         "${modifier}+shift+Left" = "move left";
         "${modifier}+shift+Right" = "move right";
         "${modifier}+shift+Up" = "move up";
         "${modifier}+shift+Down" = "move down";
         "Print" = "exec maim --format png | xclip -selection clipboard -t image/png -i";
         "${modifier}+Print" = "exec maim -s --format png | xclip -selection clipboard -t image/png -i";
         "${modifier}+1" = "workspace 1";
         "${modifier}+2" = "workspace 2";
         "${modifier}+3" = "workspace 3";
         "${modifier}+4" = "workspace 4";
         "${modifier}+5" = "workspace 5";
         "${modifier}+6" = "workspace 6";
         "${modifier}+7" = "workspace 7";
         "${modifier}+8" = "workspace 8";
         "${modifier}+9" = "workspace 9";
         "${modifier}+Shift+1" = "move container to workspace 1";
         "${modifier}+Shift+2" = "move container to workspace 2";
         "${modifier}+Shift+3" = "move container to workspace 3";
         "${modifier}+Shift+4" = "move container to workspace 4";
         "${modifier}+Shift+5" = "move container to workspace 5";
         "${modifier}+Shift+6" = "move container to workspace 6";
         "${modifier}+Shift+7" = "move container to workspace 7";
         "${modifier}+Shift+8" = "move container to workspace 8";
         "${modifier}+Shift+9" = "move container to workspace 9";
         "${modifier}+f" = "fullscreen toggle";
         "${modifier}+space" = "floating toggle";
         "${modifier}+h" = "split h";
         "${modifier}+v" = "split v";
         "${modifier}+o" = ''exec xdg-open "obsidian://open?vault=Codex%20Astartes"'';
         "${modifier}+shift+minus" = "move scratchpad";
         "${modifier}+minus" = "scratchpad show";
         "${modifier}+Escape" = "exec --no-startup-id dm-tool lock";
         "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` +5%";
         "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` -5%";
         "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` ndtoggle";
        };
      };

      extraConfig = ''
        mouse_warping none
        new_window pixel 1
        new_float normal
        smart_gaps on
        for_window [class="(?i)firefox" instance="^(?!Navigator$)"] floating enable
        for_window [title="i3_help"] floating enable sticky enable border normal
        for_window [class="Lightdm-gtk-greeter-settings"] floating enable
        for_window [class="Lxappearance"] floating enable sticky enable border
        for_window [class="Pavucontrol"] floating enable
        for_window [class="qt5ct"] floating enable sticky enable border normal

        floating_minimum_size 500 x 300
        floating_maximum_size 2000 x 1500
        floating_modifier Mod4
        # Theme colors
        client.focused #56737a #1e1e20 #56737a #56737a #56737a
        client.focused_inactive #56737a #1e1e20 #56737a #2c5159 #2c5159
        client.unfocused #56737a #1e1e20 #56737a #2c5159 #2c5159
        client.urgent #56737a #1e1e20 #56737a #2c5159 #2c5159
        client.placeholder #56737a #1e1e20 #56737a #2c5159 #2c5159
        client.background #1e1e20
        '';
        
      };
    };
}
