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

      " Editor config
      let g:EditorConfig_exclude_patterns = ['fugitive://.*']


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
      let g:vimwiki_use_mouse = 1
      let g:vimwiki_global_ext = 0


      " Completion options
      set completeopt=menuone,noinsert,noselect
      let g:completion_matching_strategy_list = [ 'exact', 'substring', 'fuzzy' ]

      " LSP Config
      lua << EOF
      local lspconfig = require'lspconfig'

      -- Python
      lspconfig.pyright.setup {
        on_attach=require'completion'.on_attach;
        cmd = {'${pkgs.nodePackages.pyright}/bin/pyright-langserver', '--stdio'};
      }

      -- Bash
      lspconfig.bashls.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.nodePackages.bash-language-server}/bin/bash-language-server', 'start'};
      }

      -- GO
      lspconfig.gopls.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.gopls}/bin/gopls' };
      }

      -- NIX
      lspconfig.rnix.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.rnix-lsp}/bin/rnix-lsp' };
      }

      -- Ruby
      lspconfig.solargraph.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.solargraph}/bin/solargraph', 'stdio' };
      }

      -- Rust
      lspconfig.rust_analyzer.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.rust-analyzer}/bin/rust-analyzer' }; 
      }

      -- Terraform
      lspconfig.terraformls.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.terraform-ls}/bin/terraform-ls', 'serve' };
      }

      -- Typescript
      lspconfig.tsserver.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio' };
      }

      -- Vim script
      lspconfig.vimls.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.nodePackages.vim-language-server}/bin/vim-language-server', '--stdio' };
      }

      -- YAML
      lspconfig.yamlls.setup {
        on_attach=require'completion'.on_attach;
        cmd = { '${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server', '--stdio' };
      }

      EOF


      " LSP Config
      "lua << EOF
      "require'lspconfig'.pyright.setup{ on_attach=require'completion'.on_attach }
      "EOF

      "if executable('rnix-lsp')
      "     au User lsp_setup call lsp#register_server({
      "  \ 'name': 'rnix-lsp',
      "  \ 'cmd': {server_info->[&shell, &shellcmdflag, 'rnix-lsp']},
      "  \ 'whitelist': ['nix'],
      "  \ })
      "endif

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
      calendar-vim
      vim-nix
      lightline-vim
      vim-fugitive
      popup-nvim
      plenary-nvim
      telescope-nvim
      nvim-web-devicons
      nvim-tree-lua
      vim-startify
      nvim-lspconfig
      completion-nvim
      barbar-nvim
      editorconfig-vim
    ];

  };

  home.packages = with pkgs; [
    nodejs
    omnisharp-roslyn
    mono
    rnix-lsp
    clang-tools
    rustup
  ];

}
