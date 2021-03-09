{pkgs, config, lib, stdenv, ...}:
with stdenv.lib;

{
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim-nightly}/bin/nvim";
  };

  programs.neovim = {
    enable = true;

    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      black
      flake8
    ]);

    extraConfig = ''
      colorscheme nord
      set t_Co=256

      set exrc
      set nohlsearch
      set incsearch
      set scrolloff=8
      set colorcolumn=80
      set nowrap
      syntax on

      " Map leader key
      nnoremap <SPACE> <Nop>
      let mapleader=" "
      let maplocalleader=" "

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
      set ai
      set si
      set pyxversion=3
      set cmdheight=2
      set updatetime=300
      set shortmess+=c
      set signcolumn=yes
      set noerrorbells
      set novisualbell
      set t_vb=
      set tm=500
      set hidden
      set splitbelow
      set splitright


      let g:lightline = { 'colorscheme': 'wombat',
      \ 'active': {
      \    'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly',
      \                'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ }
      \ }


      " NVIM Tree
      let g:nvim_tree_side = 'left'
      let g:nvim_tree_width = 40
      let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
      let g:nvim_tree_auto_open = 1
      let g:nvim_tree_auto_close = 1
      let g:nvim_tree_follow = 1
      let g:nvim_tree_indent_markers = 1
      let g:nvim_tree_hide_dotfiles = 0
      let g:nvim_tree_git_hl = 1
      let g:nvim_tree_root_folder_modifier = ':~'
      let g:nvim_tree_tab_open = 1
      let g:nvim_tree_disable_netrw = 1
      let g:nvim_tree_hijack_netrw = 1
      let g:nvim_tree_show_icons = {
          \ 'git': 1,
          \ 'folders': 1,
          \ 'files': 1,
          \ }
      let g:nvim_tree_icons = {
          \ 'default': '',
          \ 'symlink': '',
          \ 'git': {
          \   'unstaged': "✗",
          \   'staged': "✓",
          \   'unmerged': "",
          \   'renamed': "➜",
          \   'untracked': "★"
          \   },
          \ 'folder': {
          \   'default': "",
          \   'open': "",
          \   'empty': "",
          \   'empty_open': "",
          \   'symlink': "",
          \   }
          \ }

      let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown',
      \ 'ext': '.md', 'path_html': '~/vimwiki/site_html',
      \ 'custom_wikihtml': 'vimwiki_markdown'}]

      " Disable arrow keys in normal mode
      map <up> <nop>
      map <down> <nop>
      map <left> <nop>
      map <right> <nop>

      " Disable arrow keys in insert mode
      imap <up> <nop>
      imap <down> <nop>
      imap <left> <nop>
      imap <right> <nop>

      " Telescope command
      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>


      nnoremap <leader>nn :NvimTreeToggle<CR>
      nnoremap <leader>nr :NvimTreeRefresh<CR>
      set termguicolors

      " Startify
      let g:startify_custom_header = [ '      NIXOS NEOVIM CONFIG' ]

    '';

    plugins = with pkgs.vimPlugins; [
      nord-vim
      vimwiki
      vim-nix
      lightline-vim
      vim-fugitive
      vimagit
      popup-nvim
      plenary-nvim
      telescope-nvim
      nvim-web-devicons
      nvim-tree-lua
      vim-startify
      nvim-lspconfig
      completion-nvim
    ];

  };

  home.packages = with pkgs; [
    #neovim-nightly

    #neovitality

    #(python3.withPackages (ps: with ps; [
    #  black   flake8
    #  flake8
    #]))

    nodejs
    omnisharp-roslyn
    mono
    rnix-lsp
    clang-tools
    rustup
  ];

  home.file = {
    #".config/nvim/init.vim".source = ./init.vim;
    #".local/share/nvim/site/autoload/plug.vim".source = ./plug.vim;
    #".config/nvim/coc-settings.json".source = ./coc-settings.json;
  };


  # So getting nvim to install it during activation. A bit of a hack
 # home.activation.neovim = lib.hm.dag.entryAfter ["writeBoundry"] ''
 #   nvim -c 'PlugInstall|q|q'
  #'';
}
