{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = wayland;
in {

  config = mkIf desktopMode {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      # extraOptions = [ "--debug" ]; # Use this option to send sway logs to journalctl 
      extraPackages = with pkgs; [
        waybar
        swaybg
        wofi
        imv
      ];
    };

    sys.users.allUsers.files = {
      swaybarconfig = {
        path = ".config/waybar/config";
        text = ''
          {
            "layer": "top",
            "modules-left": ["sway/workspaces", "sway/mode"],
            "modules-right": [ "network", "memory", "cpu", "pulseaudio", "custom/disk_root", "tray", "clock" ],
            "sway/window": {
              "max-length": 50
            },
            "memory": {
              "interval": 30,
              "format": "{used:0.1f}G/{total:0.1f}G "
            },
            "cpu": {
                "interval": 10,
                "format": "{}% ",
                "max-length": 10
            },
            "pulseaudio": {
                "format": "{volume}% {icon}",
                "format-bluetooth": "{volume}% {icon}",
                "format-muted": "",
                "format-icons": {
                    "headphone": "",
                    "hands-free": "",
                    "headset": "",
                    "phone": "",
                    "portable": "",
                    "car": "",
                    "default": ["", ""]
                },
                "scroll-step": 1,
                "on-click": "pavucontrol"
            },
            "custom/disk_root": {
              "format": "💽 / {} ",
              "interval": 30,
              "exec": "df -h --output=avail / | tail -1 | tr -d ' '"
            },
            "clock": {
              "format": "{:%a, %d. %b  %H:%M}"
            },
            "tray": {
              "spacing": 10
            },

            "network": {
                "interface": "enp5s0",
                "format": "{ifname}",
                "format-ethernet": "{ipaddr}/{cidr} ",
                "format-disconnected": "", //An empty format will hide the module.
                "tooltip-format": "{ifname} via {gwaddr} ",
                "tooltip-format-wifi": "{essid} ({signalStrength}%) ",
                "tooltip-format-ethernet": "{ifname} ",
                "tooltip-format-disconnected": "Disconnected",
                "max-length": 50
            }

          }
        '';
      };

      swatconfig = {
        path = ".config/sway/config";
        text = ''
          font pango:monospace 8.000000
          floating_modifier Mod4
          default_border pixel 2
          default_floating_border pixel 2
          hide_edge_borders none
          focus_wrapping no
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
          bindsym Mod4+Return exec /run/current-system/sw/bin/alacritty
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
          bindsym Mod4+Shift+r reload
          bindsym Mod4+Up focus up
          bindsym Mod4+d exec /run/current-system/sw/bin/rofi -show drun
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
          bindsym Mod4+w exec wks run browsers firefox
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

          gaps inner 20
          gaps outer -4


          exec --no-startup-id /run/current-system/sw/bin/waybar
          exec --no-startup-id systemctl --user restart gpg-agent.service
          exec --no-startup-id desktop wallpaper

          mouse_warping none
          default_border pixel 1
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

          output DP-1 pos 0 0
          output HDMI-A-1 pos 3840 0
          output DP-2 pos 7680 0
        '';
      };
    };
  };
}
