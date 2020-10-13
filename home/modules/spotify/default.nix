{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.wil.spotify;
in {

  options.wil.spotify = {
    enable = mkEnableOption "Specify is spotify is installed or not on this system";  
  };

  config = mkIf(cfg.enable) {
    home.file = {
      ".config/spotifyd/config".source = ../../../.secret/spotifyd/spotifyd.conf;
    };


    systemd.user.services.spotifyd = {
      Service = {
        ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --config-path ~/.config/spotifyd/config";
        Restart = "always";
        RestartSec = 6;
      };

      Unit = {
        After = "graphical-session-pre.target";
        Description = "Spotify Daemon";
        PartOf = "graphical-session.target";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home.packages = with pkgs; [
      spotifyd
      spotify-tui
    ];
  };


}
