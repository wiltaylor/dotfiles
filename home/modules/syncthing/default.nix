{pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.wil.syncthing;
in {
  
  options.wil.syncthing = {
    enable = mkEnableOption "Enable syncthing";
  };

  config = mkIf (cfg.enable) {
    services.syncthing.enable = true;
  };
}
