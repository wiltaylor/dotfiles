{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.polybar;
in {
  options.wil.polybar = {
    enable = mkEnableOption "Enable polybar";
  };

  config = mkIf (cfg.enable) {
      services.polybar = {
        enable = true;
        script = "polybar -q -r top1 & polybar -q -r top2 & polybar -q -r top3 & polybar -q -r top4 & polybar -q -r top5 & polybar -q -r top6 &";
  
        package = pkgs.polybar.override {
          i3GapsSupport = true;
        };

        config = rec {    
	        templatebar = {
	          width = "100%";
	          height = "2%";
	          radius = 0;
	          background = "#1e1e20";
	          foreground = "#c5c8c6";
	          line-size = 3;
	          border-size = 0;
	          padding-left = 2;
	          padding-right = 2;
	          module-margin-left = 1;
	          module-margin-right = "0.5";

	          font-0 = "Source Code Pro Semibold:size=18;1";
	          font-1 = "Font Awesome 5 Free:style=Solid:size=18;1";
	          font-2 = "Font Awesome 5 Brands:size=18;1";
	          modules-left = "powermenu i3";
	          modules-right = "bat0 bat1 wifi0 wifi1 eth0 audio clock";
	          tray-position = "right";
	          tray-maxsize = 32;
	          cursor-click = "pointer";
	          cursor-scroll = "ns-resize";
	        };

	        templatewlan = {
	          type = "internal/network";
            interval = "3.0";

            format-connected = "<ramp-signal> <label-connected>";
	          format-connected-background = "#1e1e20";
	          format-connected-padding = "0.5";
	          label-connected = "%essid% %local_ip%";

	          ramp-signal-0 = " ";
	          ramp-signal-1 = " ";
	          ramp-signal-2 = " ";
	          ramp-signal-3 = " ";
	          ramp-signal-4 = " ";
	        };

	        templateeth = {
	          type = "internal/network";
	          interval = "3.0";

	          format-connected-padding = "2";
	          format-connected-background = "#1e1e20";
	          format-connected-prefix = " ";
	          label-connected = "%local_ip%";
	        };

	        templatebat = {
	          type = "internal/battery";
	          full-at = "100";
	          poll-interval = 5;
	          format-charging = "<animation-charging><label-charging>";
	          format-discharging = "<ramp-capacity><label-discharging>";
	          format-full = "<ramp-capacity><label-full>";
	          label-charging = "%percentage%%";
	          label-discharging = "%percentage%%";
	          label-full = "Full";

	          ramp-capacity-0 = " ";
	          ramp-capacity-1 = " ";
	          ramp-capacity-2 = " ";
	          ramp-capacity-3 = " ";
	          ramp-capacity-4 = " ";

	          bar-capacity-width = 10;

	          animation-charging-0 = " ";
	          animation-charging-1 = " ";
	          animation-charging-2 = " ";
	  
	          animation-charging-3 = " ";
	          animation-charging-4 = " ";
	          animation-charging-framerate = 750;

	          animation-discharging-0 = " ";
	          animation-discharging-1 = " ";
	          animation-discharging-2 = " ";
	          animation-discharging-3 = " ";
	          animation-discharging-4 = " ";
	          animation-discharging-framerate = 500;
	        };

	        bat0 = {
	          battery = "BAT0";
	          adapter = "AC";
	        };

	        bat1 = {
	          battery = "BAT1";
	          adapter = "ADP1";
	        };

	        wifi0 = {
	          interface = "wlp2s0";
	        };

	        wifi1 = {
	          interface = "wlp63s0";
	        };

	        eth0 = {
	          interface = "enp62s0";
	        };

	        dp0 = {
	          monitor = "DP-0";
	        };

	        dp2 = {
	          monitor = "DP-2";
	        };

	        dp3 = {
            monitor = "DP-4";
	        };

	        dp0-mini = {
            monitor = "eDP1";
	        };

	        dp1-mini = {
	          monitor = "DP1-1";
	        };	

	        dp2-mini = {
	          monitor = "DP1-2";
	        };

	        "bar/top1" = templatebar // dp0;
	        "bar/top2" = templatebar // dp2;
	        "bar/top3" = templatebar // dp3;
	        "bar/top4" = templatebar // dp0-mini;
	        "bar/top5" = templatebar // dp1-mini;
	        "bar/top6" = templatebar // dp2-mini;

	        "module/wifi0" = templatewlan // wifi0;
	        "module/wifi1" = templatewlan // wifi1;
	        "module/eth0" = templateeth // eth0;
	        "module/bat0" = templatebat // bat0;
	        "module/bat1" = templatebat // bat1;

	        "module/i3" = {
	          type = "internal/i3";
	          format = "<label-state> <label-mode>";

	          label-mode-padding = 2;
	          label-mode-foreground = "#1e1e20";
	          label-mode-background = "#56737a";

	          label-focused = "%index%";
	          label-focused-background = "#2c5159";
            label-focused-foreground = "#6b7443";
            label-focused-padding = 2;

            label-unfocused = "%index%";
            label-unfocused-background = "#56737a";
            label-unfocused-foreground = "#1e1e20";
            label-unfocused-padding = 2;

            label-visible = "%index%";
            label-visible-background = "#56737a";
            label-visible-foreground = "#1e1e20";
            label-visible-padding = 2;

            label-urgent = "%index%";
            label-urgent-background = "#BA2922";
            label-urgent-padding = 2;
	        };

	        "global/wm" = {
	          margin-top = 0;
	          margin-bottom = 0;
	        };

	        "module/audio" = {
	          type = "internal/pulseaudio";
	          use-ui-max = "true";
	          format-volume = "<ramp-volume> <label-volume>";
	          label-muted = " ";
	          click-right = "pavucontrol &";

	          ramp-volume-0 = " ";
	          ramp-volume-1 = " ";
	          ramp-volume-2 = " ";
	        };

	        "module/clock" = {
	          type = "internal/date";
            interval = 5;

            date = "%Y-%m-%d";
            date-alt = " %Y-%m-%d";

            time = "%H:%M:%S";
            time-alt = "%H:%M:%S";

	          format-padding = 1;
	          label = " %date% %time%";
	        };

	        "module/powermenu" = {
	          type = "custom/menu";
	          expand-right = "true";
	          format-spacing = 1;

	          label-open = " ";
	          label-open-foreground = "#56737a";
	          label-close = " cancel";
	          label-close-foreground = "#56737a";
	          label-separator = "|";
	          label-separator-foreground = "#80969b";

	          menu-0-0 = "reboot";
	          menu-0-0-exec = "menu-open-1";
	          menu-0-1 = "power off";
	          menu-0-1-exec = "menu-open-2";
	          menu-0-2 = "log off";
	          menu-0-2-exec = "menu-open-3";

	          menu-1-0 = "reboot";
	          menu-1-0-exec = "reboot";
	          menu-1-1 = "cancel";
	          menu-1-1-exec = "menu-open-0";

	          menu-2-0 = "power off";
	          menu-2-0-exec = "poweroff";
	          menu-2-1 = "cancel";
	          menu-2-1-exec = "menu-open-0";

	          menu-3-0 = "log off";
	          menu-3-0-exec = "i3-msg exit";
	          menu-3-1 = "cancel";
	          menu-3-1-exec = "menu-open-0";
	        };
        };
      };
    };
}
