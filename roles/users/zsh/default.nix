{pkgs, config, lib, ...}:
{
  home.packages = with pkgs; [
    spaceship-prompt
    nix-zsh-completions
    direnv
  ];

  home.file = {
    ".config/starship.toml".source = ./starship.toml;
  };
    
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    plugins = [
      {
        name = "spaceship-prompt";
        src = "${pkgs.spaceship-prompt}/share/zsh/site-functions";
      }
    ];

    initExtraBeforeCompInit = ''
      # Set bigger history size
      export HISTFILESIZE=1000000000
      export HISTSIZE=1000000000

      # Setup history to ignore lines starting with
      # space and duplicates.
      setopt autocd
      setopt append_history
      setopt hist_ignore_dups
      setopt hist_ignore_space
      export HISTTIMEFORMAT="[%F %T] "
      setopt EXTENDED_HISTORY

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

      eval "$(direnv hook zsh)"
    '';

    initExtra = ''
      autoload -U promptinit; promptinit
      prompt spaceship
    '';
  };
}
