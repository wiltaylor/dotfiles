{pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.wil.vscode;
in {
  options.wil.vscode = {
    enable = mkEnableOption "VSCodium";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      vscodium
      wil.vscodium-alias
    ];
  };
}
