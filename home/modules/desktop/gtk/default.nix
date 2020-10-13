{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.gtk;
in {

  options.wil.gtk = {
    enable = mkEnableOption "Enable GTK settings";
  };

  config = mkIf (cfg.enable) {
    home.file = {
      ".config/gtk-4.0/settings.ini".source = ./4/settings.ini;
      ".config/gtk-3.0/settings.ini".source = ./3/settings.ini;
      ".config/gtk-3.0/colors.css".source = ./3/colors.css;
      ".config/gtk-3.0/gtk.css".source = ./3/gtk.css;
    };

    home.packages = with pkgs; [
      breeze-gtk
    ];
  };

}
