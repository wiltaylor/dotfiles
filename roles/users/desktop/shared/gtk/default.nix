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

    home.file = {
      ".config/gtk-4.0/settings.ini".source = ./4/settings.ini;
      ".config/gtk-3.0/settings.ini".source = ./3/settings.ini;
      #".config/gtk-3.0/colors.css".source = ./3/colors.css;
      #".config/gtk-3.0/gtk.css".source = ./3/gtk.css;
    };

    home.packages = with pkgs; [
      breeze-gtk
    ];

}
