{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.wil.tmux;
in {
  options.wil.tmux = {
    enable = mkEnableOption "Enable tmux";
  };

  config = mkIf (cfg.enable) {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      escapeTime = 0;
      aggressiveResize = true;
      keyMode = "vi";
      shortcut = "a";

      extraConfig = ''
        setw -g mouse on
      '';
    };
  };
}
