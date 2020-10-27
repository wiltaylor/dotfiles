{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.wil.games;
in {

  options.wil.games = {
    enable = mkEnableOption "Enable 32bit libs for games";
  };

  config = mkIf (cfg.enable) {
    hardware.opengl = {
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ];
    };

    hardware.pulseaudio.support32Bit = true;
    hardware.steam-hardware.enable = true;
  };
}
