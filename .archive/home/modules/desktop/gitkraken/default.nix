{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.gitkraken;
in {
  options.wil.gitkraken = {
    enable = mkEnableOption "Enable git kraken";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs;[
      gitkraken
    ];
  };
}
