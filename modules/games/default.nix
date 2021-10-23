{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  cfg = config.sys.games;
in {
  options.sys.games = {
    enable = mkEnableOption "Enables games";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steam
      steam-run
      xonotic
      vkquake
      minecraft
      quakespasm
    ];
  };
}
