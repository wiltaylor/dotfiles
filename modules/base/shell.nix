{pkgs, lib, config, ...}:
with pkgs;
with lib;
with builtins;
let
    cfg = config.sys;
in {
    sys.software = [
        zsh
        nushell
        spaceship-prompt
    ];

    users.defaultUserShell = pkgs.nushell;

    environment.variables= {
      "EDITOR" = "nvim";
      "VISUAL" = "nvim";
    }; 

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
}
