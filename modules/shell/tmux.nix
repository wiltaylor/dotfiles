{pkgs, config, lib, ...}:
with builtins;
with lib;
let
  cfg = config.sys.shell;
in {
  options.sys.shell = {
    tmux = mkOption {
      type = types.bool;
      default = true;
      description = "Enable tmux for all use on this system";
    };
  };

  config = mkIf cfg.tmux {
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
