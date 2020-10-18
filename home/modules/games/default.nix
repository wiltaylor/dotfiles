{pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.wil.games;
in {
  
  options.wil.games = {
    enable = mkEnableOption "Enable games on system";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs;[
      steam
    ];
  };
}

