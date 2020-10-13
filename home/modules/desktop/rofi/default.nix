{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.rofi;
in {
  options.wil.rofi = {
    enable = mkEnableOption "Enable rofi";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      rofi
    ];
  };
}
