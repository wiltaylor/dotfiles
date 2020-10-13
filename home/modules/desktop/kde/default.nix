{pkgs, config, lib, ... }:
with lib;
let 
  cfg = config.wil.kde;
in {
  options.wil.kde = {
    enable = mkEnableOption "Enable kde configurations";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      breeze-qt5
    ];

    home.file = {
      ".kde4/share/config/kdeglobals".source = ./kdeglobals;
      ".kde4/share/apps/color-schemes/Breeze.colors".source = ./Breeze.colors;
      ".kde4/share/apps/color-schemes/BreezeDark.colors".source = ./BreezeDark.colors;
    };
  };
}
