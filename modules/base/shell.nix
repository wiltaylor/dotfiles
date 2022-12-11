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
        bash
        spaceship-prompt
    ];

    users.defaultUserShell = pkgs.nushell;

    sys.user.allUsers.files = {
        filea = {
            path = ".config/nushell/config.nu";
            text = readFile ./config.nu;
        };

        fileb = {
            path = ".config/nushell/env.nu";
            text = readFile ./env.nu;
        };
    };

    environment.variables= {
      "EDITOR" = "nvim";
      "VISUAL" = "nvim";
    }; 

    # This is so you can set zsh, bash or nushell as your interactive shell.
    # If you don't set this it will not show your user on the login screen.
    environment.shells = with pkgs; [ zsh bash nushell ];

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
