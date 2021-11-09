{pkgs, lib, config, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = xorg || wayland;
in {
  config = mkIf desktopMode {
    
    sys.users.allUsers.files = {
      dunstconfg = {
        path = ".config/dunst/dunstrc";
        text = ''
          [global]
          alignment="center"
          bounce_freq=0
          follow="mouse"
          font="Source Code Pro 12"
          format="%s
          %b"
          frame_color="#000000"
          frame_width=1
          geometry="240x3-20+30"
          horizontal_padding=5
          icon_path="/run/current-system/sw/share/icons/hicolor/32x32/actions:/run/current-system/sw/share/icons/hicolor/32x32/animations:/run/current-system/sw/share/icons/hicolor/32x32/apps:/run/current-system/sw/share/icons/hicolor/32x32/categories:/run/current-system/sw/share/icons/hicolor/32x32/devices:/run/current-system/sw/share/icons/hicolor/32x32/emblems:/run/current-system/sw/share/icons/hicolor/32x32/emotes:/run/current-system/sw/share/icons/hicolor/32x32/filesystem:/run/current-system/sw/share/icons/hicolor/32x32/intl:/run/current-system/sw/share/icons/hicolor/32x32/legacy:/run/current-system/sw/share/icons/hicolor/32x32/mimetypes:/run/current-system/sw/share/icons/hicolor/32x32/places:/run/current-system/sw/share/icons/hicolor/32x32/status:/run/current-system/sw/share/icons/hicolor/32x32/stock:/home/wil/.nix-profile/share/icons/hicolor/32x32/actions:/home/wil/.nix-profile/share/icons/hicolor/32x32/animations:/home/wil/.nix-profile/share/icons/hicolor/32x32/apps:/home/wil/.nix-profile/share/icons/hicolor/32x32/categories:/home/wil/.nix-profile/share/icons/hicolor/32x32/devices:/home/wil/.nix-profile/share/icons/hicolor/32x32/emblems:/home/wil/.nix-profile/share/icons/hicolor/32x32/emotes:/home/wil/.nix-profile/share/icons/hicolor/32x32/filesystem:/home/wil/.nix-profile/share/icons/hicolor/32x32/intl:/home/wil/.nix-profile/share/icons/hicolor/32x32/legacy:/home/wil/.nix-profile/share/icons/hicolor/32x32/mimetypes:/home/wil/.nix-profile/share/icons/hicolor/32x32/places:/home/wil/.nix-profile/share/icons/hicolor/32x32/status:/home/wil/.nix-profile/share/icons/hicolor/32x32/stock:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/actions:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/animations:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/apps:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/categories:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/devices:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/emblems:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/emotes:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/filesystem:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/intl:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/legacy:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/mimetypes:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/places:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/status:/nix/store/pm4di5pwa0wg2bk3xjk3f6ry0mkhh0d3-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/stock"
          idle_threshold=120
          ignore_newline="no"
          indicate_hidden="yes"
          line_height=0
          markup="full"
          monitor=0
          padding=5
          separator_color="frame"
          separator_height=2
          show_age_threshold=60
          show_indicators="no"
          sort="yes"
          startup_notification=yes
          sticky_history="yes"
          transparency=10
          word_wrap="yes"

          [shortcuts]
          close="ctrl+space"
          close_all="ctrl+shift+space"
          context="ctrl+shift+period"
          history="ctrl+grave"

          [urgency_critical]
          background="#000000"
          foreground="#cf6a4c"
          timeout=0

          [urgency_low]
          background="#000000"
          foreground="#ffffff"
          timeout=4

          [urgency_normal]
          background="#000000"
          foreground="#ffffff"
          timeout=6
        '';
      };
    };
  };
}
