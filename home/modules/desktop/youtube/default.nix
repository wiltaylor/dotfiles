{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.youtube;
in {
  options.wil.youtube = {
     enable = mkEnableOption "Enable youtube downloader";
  };

  config = mkIf (cfg.enable) {
    home.packages =  with pkgs; [
      youtube-dl
      youtube-viewer
    ];
  };
}
