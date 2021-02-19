{pkgs, config, lib, stdenv, ...}:
with stdenv.lib;

{
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  home.packages = with pkgs; [
    neovim
    python3
    nodejs
    omnisharp-roslyn
    mono
  ];

  home.file = {
    ".config/nvim/init.vim".source = ./init.vim;
    ".local/share/nvim/site/autoload/plug.vim".source = ./plug.vim;
  };


  # So getting nvim to install it during activation. A bit of a hack
  home.activation.neovim = lib.hm.dag.entryAfter ["writeBoundry"] ''
    nvim -c 'PlugInstall|q|q'
    #nvim -c 'CocInstall -sync coc-explorer coc-tsserver coc-json coc-html coc-css coc-yaml coc-git coc-prettier coc-angular coc-clangd coc-cmake coc-diagnostic coc-git coc-go coc-java coc-markdownlint coc-omnisharp coc-powershell coc-python coc-rls coc-sh coc-spell-checker coc-sql coc-svg coc-swagger coc-texlab coc-toml coc-xml coc-yaml |q|q'
  '';
} 
