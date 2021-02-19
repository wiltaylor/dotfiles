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
    rnix-lsp
  ];

  home.file = {
    ".config/nvim/init.vim".source = ./init.vim;
    ".local/share/nvim/site/autoload/plug.vim".source = ./plug.vim;
    ".config/nvim/coc-settings.json".source = ./coc-settings.json;
  };


  # So getting nvim to install it during activation. A bit of a hack
  home.activation.neovim = lib.hm.dag.entryAfter ["writeBoundry"] ''
    nvim -c 'PlugInstall|q|q'
  '';
} 
