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
          ${config.sys.desktop.tilewm.extraConfig}
          ${config.sys.desktop.tilewm.extraConfigSway}
        '';
      };
    };
  };
}
