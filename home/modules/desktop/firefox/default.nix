{pkgs, lib, config, ...}:
with lib;
let 
  cfg = config.wil.firefox;
in {
  options.wil.firefox = {
    enable = mkEnableOption "Enable firefox browser";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      firefox
    ];
  };
}
