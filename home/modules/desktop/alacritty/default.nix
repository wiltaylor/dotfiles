{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.wil.alacritty;
in {
  options.wil.alacritty = {
    enable = mkEnableOption "Enable Alacritty terminal";
  };

  config = mkIf(cfg.enable) {
    
    home.packages = with pkgs; [
      alacritty
    ];

    home.file = {
      ".config/alacritty/alacritty.yml".source = ./alacritty.yml;
    };
  };
}
