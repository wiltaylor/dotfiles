{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.audio;
in {
  config = mkIf (cfg.server == "pulse") {
    sound.enable = true;

    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.support32Bit = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
  };
}
