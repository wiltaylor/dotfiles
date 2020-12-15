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
  ];

  home.file = {
    ".config/nvim/init.vim".source = ./init.vim;
    ".local/share/nvim/site/autoload/plug.vim".source = ./plug.vim;
  };


  #TODO: Bug with coc-explorer not installing properly.
  # So getting nvim to install it during activation. A bit of a hack
  home.activation.neovim = lib.hm.dag.entryAfter ["writeBoundry"] ''
    nvim -c 'PlugInstall|q|q'
    nvim -c 'CocInstall -sync coc-explorer coc-tsserver coc-json coc-html coc-css coc-yaml coc-git |q|q'
  '';

#  programs.neovim = {
#    enable = true;
#    vimAlias = true;
#    viAlias = true;
#    vimdiffAlias = true;
#    withNodeJs = true;
#    withPython3 = true;
#
#    extraPython3Packages = ps: with ps;[
#      pylint
#      python-language-server
#      pip
#    ];
#
#    plugins = with pkgs.unstable.vimPlugins; [
##      coc-python
#      coc-tsserver
##      coc-wxml
##      coc-markdownlint
##      coc-vimlsp
##      coc-vimtex
##      coc-snippets
##      coc-rls
##      coc-jest
##      coc-go
##      coc-eslint
#      fzf-vim
#    ];
#
#    extraConfig = ''
#      " Basic editor config
#      set clipboard+=unnamedplus
#      set mouse=a
#      set encoding=utf-8
#      set number relativenumber
#      set noswapfile
#      set nobackup
#      set nowritebackup
#      set tabstop=2
#      set shiftwidth=2
#      set softtabstop=2
#      set expandtab
#      set ai "Auto indent
#      set si "Smart indent
#      set pyxversion=3 "Avoid using python 2 when possible, its eol
#      set hidden " coc needs this or TextEdit can fail
#      set cmdheight=2 " for coc
#      set updatetime=300
#      set shortmess+=c
#      set signcolumn=yes
#
#      " Mapping tab complete for coc
#      inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
#      inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
#      inoremap <silent><expr> <c-space> coc#refresh() " Space to trigger completion
#      inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
#
#      " Use `[g` and `]g` to navigate diagnostics
#      " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
#      nmap <silent> [g <Plug>(coc-diagnostic-prev)
#      nmap <silent> ]g <Plug>(coc-diagnostic-next)
#
#      " GoTo code navigation.
#      nmap <silent> gd <Plug>(coc-definition)
#      nmap <silent> gy <Plug>(coc-type-definition)
#      nmap <silent> gi <Plug>(coc-implementation)
#      nmap <silent> gr <Plug>(coc-references)
#
#      " Highlight the symbol and its references when holding the cursor.
#      autocmd CursorHold * silent call CocActionAsync('highlight')
#
#      " Symbol renaming.
#      nmap <leader>rn <Plug>(coc-rename)
#
#      " Formatting selected code.
#      xmap <leader>f  <Plug>(coc-format-selected)
#      nmap <leader>f  <Plug>(coc-format-selected)
#
#      " Applying codeAction to the selected region.
#      " Example: `<leader>aap` for current paragraph
#      xmap <leader>a  <Plug>(coc-codeaction-selected)
#      nmap <leader>a  <Plug>(coc-codeaction-selected)
#
#
#      " Remap keys for applying codeAction to the current buffer.
#      nmap <leader>ac  <Plug>(coc-codeaction)
#      " Apply AutoFix to problem on the current line.
#      nmap <leader>qf  <Plug>(coc-fix-current)
#
#      " Map function and class text objects
#      " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
#      xmap if <Plug>(coc-funcobj-i)
#      omap if <Plug>(coc-funcobj-i)
#      xmap af <Plug>(coc-funcobj-a)
#      omap af <Plug>(coc-funcobj-a)
#      xmap ic <Plug>(coc-classobj-i)
#      omap ic <Plug>(coc-classobj-i)
#      xmap ac <Plug>(coc-classobj-a)
#      omap ac <Plug>(coc-classobj-a)
#
#      nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
#      nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
#      inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
#      inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
#      vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
#      vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
#
#      nmap <silent> <C-s> <Plug>(coc-range-select)
#      xmap <silent> <C-s> <Plug>(coc-range-select)
#
#      command! -nargs=0 Format :call CocAction('format')
#      command! -nargs=? Fold :call     CocAction('fold', <f-args>)
#      command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
#      " set statusline^=%{coc#status()}%{get(b:,'coc_current_function',' ')}
#
#      :nmap <space>e :CocCommand explorer<CR>
#
#      function! s:check_back_space() abort
#        let col = col('.') - 1
#        return !col || getline('.')[col - 1]  =~# '\s'
#      endfunction
#
#      " No annoying sound on errors
#      set noerrorbells
#      set novisualbell
#      set t_vb=
#      set tm=500
#
#      "Colour theme
#      colorscheme nord
#      let g:lightline = { 'colorscheme': 'nord', }
#
#      "COC settings
#      map <a-cr> :CocAction<CR>
#      "Vim wiki settings
#      let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md', 'path_html': '~/vimwiki/site_html', 'custom_wiki2html': 'vimwiki_markdown'}]
#
#      " Disable Arrow keys in Normal mode
#      map <up> <nop>
#      map <down> <nop>
#      map <left> <nop>
#      map <right> <nop>
#
#      " Disable Arrow keys in Insert mode
#      imap <up> <nop>
#      imap <down> <nop>
#      imap <left> <nop>
#      imap <right> <nop>
#  '';
#  };
}
  
