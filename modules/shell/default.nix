{pkgs, config, lib, ...}:
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

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      shellInit = ''
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        
        # Simple keybindings for moving around commands in history.
        bindkey -e      
        bindkey "$terminfo[khome]" beginning-of-line # Home
        bindkey "$terminfo[kend]" end-of-line # End
        bindkey "$terminfo[kich1]" overwrite-mode # Insert
        bindkey "$terminfo[kdch1]" delete-char # Delete
        bindkey "$terminfo[kcuu1]" up-line-or-history # Up
        bindkey "$terminfo[kcuu1]" up-line-or-history # Up
        bindkey "$terminfo[kcub1]" backward-char # Left
        bindkey "$terminfo[kcuf1]" forward-char # Right

        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey "^[[A" up-line-or-beginning-search # Up
        bindkey "^[[B" down-line-or-beginning-search # Down

        # Create user profile 
        touch ~/.zshrc
      '';

      promptInit = ''
        autoload -U promptinit; promptinit
        prompt spaceship
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
