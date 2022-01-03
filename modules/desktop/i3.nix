{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  desktopMode = xorg;
in {

  config = mkIf desktopMode {
    services.xserver.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3blocks-gaps
        my.i3blocks-contrib
        sysstat
      ];
    };

    sys.users.allUsers.files = {
      i3blocksconfig = {
        path = ".config/i3/i3blocks.conf";
        text = ''
          [cpu_usage]
          command=echo " $(grep 'cpu ' /proc/stat | awk '{usage=int(($2+$4)*100/($2+$4+$5))} END {print usage "%"}')"
          interval=5

          [memory_usage]
          command=grep -E 'MemTotal|MemFree' /proc/meminfo | awk '/MemTotal/ {total=int($2/1024)} /MemFree/ {free=int($2/1024)} {used=total-free} END {print " " used "/" total "MB"}'
          interval=5

          [diskspace]
          command=echo " $(df / -H | grep '/' | awk '{print $3 "/" $2}')"
          interval=60

          # Update time every 5 seconds
          [time]
          command=date "+%Y-%m-%d %T"
          interval=5 
        '';
      };

      i3config = {
        path = ".config/i3/config";
        text = let 
          binDir = "/run/current-system/sw/bin";
        in ''
          font pango:monospace 8.000000
          floating_modifier Mod4
          default_border pixel 2
          default_floating_border pixel 2
          hide_edge_borders none
          force_focus_wrapping no
          focus_follows_mouse yes
          focus_on_window_activation smart
          mouse_warping output
          workspace_layout default
          workspace_auto_back_and_forth no

          client.focused #4c7899 #285577 #ffffff #2e9ef4 #285577
          client.focused_inactive #333333 #5f676a #ffffff #484e50 #5f676a
          client.unfocused #333333 #222222 #888888 #292d2e #222222
          client.urgent #2f343a #900000 #ffffff #900000 #900000
          client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
          client.background #ffffff

          bindsym Mod4+1 workspace 1
          bindsym Mod4+2 workspace 2
          bindsym Mod4+3 workspace 3
          bindsym Mod4+4 workspace 4
          bindsym Mod4+5 workspace 5
          bindsym Mod4+6 workspace 6
          bindsym Mod4+7 workspace 7
          bindsym Mod4+8 workspace 8
          bindsym Mod4+9 workspace 9
          bindsym Mod4+Down focus down
          bindsym Mod4+Escape exec --no-startup-id dm-tool lock
          bindsym Mod4+Left focus left
          bindsym Mod4+Print exec maim -s --format png | xclip -selection clipboard -t image/png -i
          bindsym Mod4+Return exec ${binDir}/alacritty
          bindsym Mod4+Right focus right
          bindsym Mod4+Shift+1 move container to workspace 1
          bindsym Mod4+Shift+2 move container to workspace 2
          bindsym Mod4+Shift+3 move container to workspace 3
          bindsym Mod4+Shift+4 move container to workspace 4
          bindsym Mod4+Shift+5 move container to workspace 5
          bindsym Mod4+Shift+6 move container to workspace 6
          bindsym Mod4+Shift+7 move container to workspace 7
          bindsym Mod4+Shift+8 move container to workspace 8
          bindsym Mod4+Shift+9 move container to workspace 9
          bindsym Mod4+Shift+m exec kill-mail
          bindsym Mod4+Shift+q kill
          bindsym Mod4+Shift+r restart
          bindsym Mod4+Up focus up
          bindsym Mod4+d exec ${binDir}/rofi -show drun
          bindsym Mod4+f fullscreen toggle
          bindsym Mod4+h split h
          bindsym Mod4+minus scratchpad show
          bindsym Mod4+o exec wks run orgSys obsidian
          bindsym Mod4+shift+Down move down
          bindsym Mod4+shift+Left move left
          bindsym Mod4+shift+Right move right
          bindsym Mod4+shift+Up move up
          bindsym Mod4+shift+minus move scratchpad
          bindsym Mod4+shift+t xinput set-prop 12 "Device Enabled" 1
          bindsym Mod4+space floating toggle
          bindsym Mod4+t xinput set-prop 12 "Device Enabled" 0
          bindsym Mod4+v split v
          bindsym Mod4+w exec MOZ_USE_XINPUT2=1 ${binDir}/firefox
          bindsym Print exec maim --format png | xclip -selection clipboard -t image/png -i
          bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` -5%
          bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` ndtoggle
          bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume `pactl list short sinks | grep -m 1 RUNNING | awk '{print $1}'` +5%

          mode "resize" {
          bindsym Down resize grow height 10 px or 10 ppt
          bindsym Escape mode default
          bindsym Left resize shrink width 10 px or 10 ppt
          bindsym Return mode default
          bindsym Right resize grow width 10 px or 10 ppt
          bindsym Up resize shrink height 10 px or 10 ppt
          }


          bar {
            
            font pango:monospace 8.000000
              
            position top
            status_command ${binDir}/i3blocks -c ~/.config/i3/i3blocks.conf
            i3bar_command ${binDir}/i3bar
          }

          gaps inner 20
          gaps outer -4


          exec_always --no-startup-id ${binDir}/autorandr -c
          exec_always --no-startup-id ${binDir}/xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
          exec --no-startup-id systemctl --user restart gpg-agent.service
          exec_always --no-startup-id ${binDir}/feh --bg-fill --randomize ~/.config/wallpapers/*

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
  };
}
