{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.audio;
in {
  options.sys.audio = {
    server = mkOption {
      type = types.enum [ "pulse" "pipewire" "none" ];
      default = "none";
      description = "Audio server to use";
    };
  };

  config = let
    pulse = cfg.server == "pulse";
  in mkIf (cfg.server != "none") {
    sound.enable = true;

    hardware.pulseaudio.enable = pulse;
    hardware.pulseaudio.support32Bit = pulse;
    hardware.pulseaudio.package = mkIf pulse pkgs.pulseaudioFull;
  };
}
