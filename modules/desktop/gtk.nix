{pkgs, lib, config, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  wayland = (elem "wayland" config.sys.graphics.desktopProtocols);
  desktopMode = xorg || wayland;
in {
  config = mkIf desktopMode {

    environment.systemPackages = with pkgs; [
      breeze-gtk
    ];

    sys.users.allUsers.files = {
      gtkSettings3 = {
        path = ".config/gtk-3.0/settings.ini";
        text = ''
          [Settings]
          gtk-application-prefer-dark-theme=1
          gtk-button-images=1
          gtk-cursor-theme-name=Adwaita
          gtk-cursor-theme-size=0
          gtk-enable-event-sounds=1
          gtk-enable-input-feedback-sounds=1
          gtk-font-name=Cantarell 11
          gtk-icon-theme-name=Adwaita
          gtk-menu-images=1
          gtk-theme-name=Breeze-Dark
          gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
          gtk-toolbar-style=GTK_TOOLBAR_BOTH
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintfull
        '';
      };

      gtkSettings4 = {
        path = ".config/gtk-4.0/settings.ini";
        text = ''
          [Settings]
          gtk-application-prefer-dark-theme=1
        '';
      };

    };
  };
}
