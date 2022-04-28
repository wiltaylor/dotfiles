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
        kanshi
        swaylock
        swayidle
        slurp
        clipman
        wl-clipboard
        grim
        wlr-randr
        libinput
        wev
      ];
    };

    sys.users.allUsers.files = {
      swaybarcss = {
        path = ".config/waybar/style.css";
        text = ''
          * {
            color: rgba(255, 255, 255, 0.77);
            border: 0px;
            font-family:"system-ui";
            font-size: 0.77rem;
            margin-right: 0.2rem;
            margin-left: 0.2rem;
            padding: 0.02rem;
            padding-bottom:0.01rem;
            padding-top:0.01rem;
          }
   
          window#waybar {
              background: rgba(10, 10, 10, 0.66);
          }

          #workspaces button {
              color: rgba(99, 19, 199, 4);
              border-color: rgba(99, 19, 199, 9);
              border-style: solid;
          }     


          #workspaces button.focused {
            background-color: rgba(99, 19, 199, 45);
            border-style: solid;
          }

          #mode {
              color: rgba(255, 255, 255, 99);
          }

          #memory, #cpu, #pulseaudio, #custom-disk_root, #clock, #tray, #network, #custom-cputemp, #custom-gputemp, #custom-launcher {
              padding: 0 0.2rem 0 0.3rem;
              margin: 0.3rem;
          }
        '';
      };

      swaybarconfig = {
        path = ".config/waybar/config";
        text = ''
          {
            "layer": "top",
            "modules-left": ["custom/launcher", "sway/workspaces", "sway/mode"],
            "modules-right": [ "custom/gputemp", "custom/cputemp", "network", "memory", "cpu", "pulseaudio", "custom/disk_root", "tray","batter", "clock" ],
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
            },
            "custom/cputemp": {
              "format": "CPU: {}  ",
              "interval": 30,
              "exec": "desktop cputemp"
            },
            "custom/gputemp": {
              "format": "GPU: {}  ",
              "interval": 30,
              "exec": "desktop gputemp"
            },
            "custom/launcher": {
              "format":"  ",
              "on-click": "exec wofi --show drun -iI",
              "tooltip": false
            },
            "battery": {
                "states": {
                    "good": 75,
                    "warning": 30,
                    "critical": 15
                },
                "format": "{icon} {capacity}%",
                "format-icons": ["", "", "", "", ""]
            },
          }
        '';
      };

      swayconfig = {
        path = ".config/sway/config";
        text = ''
          ${config.sys.desktop.tilewm.extraConfig}
          ${config.sys.desktop.tilewm.extraConfigSway}
        '';
      };
    };
  };
}
