{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.audio;
in {
  config = mkIf (cfg.server == "pipewire") {
    sound.enable = false;
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      pulseaudio # This is instaleld to get access to pactl. It isn't enabled or run as a service.
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

  };
}
