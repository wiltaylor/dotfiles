{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.cli;
in {

  options.wil.cli = {
    enable = mkEnableOption "Enable basic cli tools";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      neofetch
      htop
      bat
      zip
      unzip
      file
      p7zip
      ranger
      strace
      ltrace
    ];
  };

}
