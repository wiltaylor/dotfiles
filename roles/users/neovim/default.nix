{pkgs, config, lib, ...}:
{
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  home.packages = with pkgs; [
    vimwiki-markdown
    python3
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;

    extraPython3Packages = ps: with ps;[
      pylint
      python-language-server
      pip
    ];

    plugins = with pkgs.vimPlugins; [
      nord-vim
      vim-devicons
      vimwiki
      vim-nix
      coc-nvim
      coc-python
      coc-tsserver
      coc-json
      coc-yaml
      coc-wxml
      coc-markdownlint
      coc-vimlsp
      coc-vimtex
      coc-snippets
      coc-rls
      coc-html
      coc-jest
      coc-go
      coc-git
      coc-fzf
      coc-eslint
      coc-css
      coc-explorer
      fzf-vim
    ];

    extraConfig = ''
      " Basic editor config
      set clipboard+=unnamedplus
      set mouse=a
      set encoding=utf-8
      set number relativenumber
      set noswapfile
      set nobackup
      set nowritebackup
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set expandtab
      set ai "Auto indent
      set si "Smart indent
      set pyxversion=3 "Avoid using python 2 when possible, its eol

      " No annoying sound on errors
      set noerrorbells
      set novisualbell
      set t_vb=
      set tm=500

      "Colour theme
      colorscheme nord
      let g:lightline = { 'colorscheme': 'nord', }

      "COC settings
      map <a-cr> :CocAction<CR>
      "Vim wiki settings
      let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md', 'path_html': '~/vimwiki/site_html', 'custom_wiki2html': 'vimwiki_markdown'}]

      " Disable Arrow keys in Normal mode
      map <up> <nop>
      map <down> <nop>
      map <left> <nop>
      map <right> <nop>

      " Disable Arrow keys in Insert mode
      imap <up> <nop>
      imap <down> <nop>
      imap <left> <nop>
      imap <right> <nop>
  '';
  };
}
  
