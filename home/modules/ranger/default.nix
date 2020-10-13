{pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.wil.ranger;
in {
  options.wil.ranger = {
    enable = mkEnableOption "Ranger file manager";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      ranger
    ];
  };
}
