{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.mail;
in {
  options.wil.mail = {
    enable = mkEnableOption "Enable mail";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      neomutt
      protonmail-bridge
      offlineimap
      notmuch
      taskwarrior
      vit
    ];
  };
}
