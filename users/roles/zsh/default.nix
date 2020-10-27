{pkgs, config, lib, ...}:
{
  home.packages = with pkgs; [
    spaceship-prompt
  ];

  home.file = {
    ".config/starship.toml".source = ./starship.toml;
  };
    
  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "spaceship-prompt";
        src = "${pkgs.spaceship-prompt}/share/zsh/site-functions";
      }
    ];

    initExtra = ''
      autoload -U promptinit; promptinit
      prompt spaceship
    '';
  };
}
