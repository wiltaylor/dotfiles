{pkgs, config, lib, ...}:
{
  home.packages = with pkgs; [
    spaceship-prompt
    nix-zsh-completions
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
      eval "$(direnv hook zsh)"
    '';

    initExtra = ''
      autoload -U promptinit; promptinit
      prompt spaceship
    '';
  };
}
