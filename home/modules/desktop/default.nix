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
with lib;
let
  cfg = config.wil.desktop;
in {
  imports = [
    ./alacritty
    ./dunst
    ./fonts
    ./gtk
    ./i3wm
    ./kde
    ./keyboard
    ./picom
    ./polybar
    ./rofi
    ./firefox
    ./vscodium
    ./joplin
    ./virtman
  ];

  options.wil.desktop = {
    enable = mkEnableOption "Enable desktop environment for user";
  };

  config = mkIf (cfg.enable) {

    #Misc desktop tools
    home.packages = with pkgs;[
      pavucontrol
      xorg.xmodmap
      maim
      xclip
      xorg.xev
      feh
      mpv
      ueberzug
      gimp
    ];

    home.file = {
      ".config/wallpapers".source = ../../../wallpapers;
    };

    wil.dunst.enable = true;
    wil.blockselection.enable = true;
    wil.alacritty.enable = true;

    wil.gtk.enable = true;
    wil.kde.enable = true;

    wil.polybar.enable = true;
    wil.i3wm.enable = true;
    wil.fonts.enable = true;
    wil.picom.enable = true;
    wil.rofi.enable = true;
    wil.firefox.enable = true;
  };
}
