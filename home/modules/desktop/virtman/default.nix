{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.virtman;
in {
  options.wil.virtman = {
    enable = mkEnableOption "Virt Manager";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      virt-manager
    ];
  };
}
