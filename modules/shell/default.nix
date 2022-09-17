{pkgs, config, lib,  ...}:
with builtins;
with lib;
let
  cfg = config.sys.shell;
in {
  imports = [ ./tmux.nix ];

  options.sys.shell = {
    zsh = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable zsh for use on this system";
      };
    };
  };

  config = mkIf cfg.zsh.enable {
    environment.systemPackages = with pkgs; [
      spaceship-prompt
      nix-zsh-completions
      fzf
      fzf-zsh
    ];

    users.defaultUserShell = pkgs.zsh;

    environment.variables= {
      "EDITOR" = "nvim";
      "VISUAL" = "nvim";
      "HISTFILESIZE" = "1000000000"; # Bigger history files for all users
      "HISTSIZE" = "1000000000";
      "HISTTIMEFORMAT"="[%F %T] ";
    }; 

    sys.users.allUsers.files.zshrc = {
      text = "# This is empty and the system profile is used instead";
      path = ".zshrc";
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      shellInit = ''
        alias vim="nvim"

        bindkey -v

        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        
        # Simple keybindings for moving around commands in history.
        bindkey -e      
        bindkey "$terminfo[khome]" beginning-of-line # Home
        bindkey "$terminfo[kend]" end-of-line # End
        bindkey "$terminfo[kich1]" overwrite-mode # Insert
        bindkey "$terminfo[kdch1]" delete-char # Delete
        bindkey "$terminfo[kcub1]" backward-char # Left
        bindkey "$terminfo[kcuf1]" forward-char # Right
      '';

      promptInit = ''
        autoload -U promptinit; promptinit
        prompt spaceship

        # Make history searchable
        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey "$key[Up]" up-line-or-beginning-search
        bindkey "$key[Down]" down-line-or-beginning-search
              '';

      setOptions = [
        "autocd"
        "append_history"
        "hist_ignore_dups"
        "hist_ignore_space"
        "EXTENDED_HISTORY"
      ];
    };
  }; 
}
