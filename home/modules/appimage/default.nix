{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.appimage;
in {
  options.wil.appimage = {
    enable = mkEnableOption "Enable appimage support";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      appimage-run
    ];
  };
}
