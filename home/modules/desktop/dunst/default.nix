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


{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.wil.dunst;
in {

  options.wil.dunst = {
    enable = mkEnableOption "Enable Dunst notification service";
  };

  config = mkIf (cfg.enable) {

    home.packages = with pkgs; [
      libnotify
    ];

    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = "Source Code Pro 12";
          markup = "full";
          format = "%s\n%b";
          sort = "yes";
          indicate_hidden = "yes";
          alignment = "center";
          bounce_freq = 0;
          show_age_threshold = 60;
          word_wrap = "yes";
          ignore_newline = "no";
          geometry = "240x3-20+30";
          transparency = 10;
          idle_threshold = 120;
          monitor = 0;
          follow = "mouse";
          sticky_history = "yes";
          line_height = 0;
          separator_height = 2;
          padding = 5;
          horizontal_padding = 5;
          separator_color = "frame";
          startup_notification = true;
          show_indicators = "no";
          frame_width = 1;
          frame_color = "#000000";
        };

        shortcuts = {
          close = "ctrl+space";
          close_all = "ctrl+shift+space";
          history = "ctrl+grave";
          context = "ctrl+shift+period";
        };

        urgency_low = {
          background = "#000000";
          foreground = "#ffffff";
          timeout = 4;
        };

        urgency_normal = {
          background = "#000000";
          foreground = "#ffffff";
          timeout = 6;
        };

        urgency_critical = {
          background = "#000000";
          foreground = "#cf6a4c";
          timeout = 0;
        };
      };
    };
  };
}
