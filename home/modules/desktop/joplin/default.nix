{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.joplin;
in {
  options.wil.joplin = {
    enable = mkEnableOption "Enable jopin";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      joplin-desktop
    ];
  };
}
