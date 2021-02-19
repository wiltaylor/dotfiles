scriptencoding utf-8
call plug#begin()
  Plug 'arcticicestudio/nord-vim'
  Plug 'vimwiki/vimwiki'
  Plug 'LnL7/vim-nix'
  Plug 'neoclide/coc.nvim'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'vim-scripts/DrawIt'
  Plug 'OmniSharp/omnisharp-vim'
  Plug 'dense-analysis/ale'
  Plug 'itchyny/lightline.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'antoinemadec/FixCursorHold.nvim'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/fern-hijack.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
call plug#end()

set exrc
set nohlsearch
set nowrap
set incsearch
set scrolloff=8
set colorcolumn=80

" Set leader to space
nnoremap <SPACE> <Nop>
let mapleader=" "
let maplocalleader=" "

let g:coc_global_extensions=[ "coc-tsserver", "coc-json", "coc-html", "coc-css", "coc-yaml", "coc-git", "coc-angular", "coc-clangd", "coc-cmake", "coc-diagnostic", "coc-git", "coc-go", "coc-java", "coc-markdownlint", "coc-omnisharp", "coc-powershell", "coc-python", "coc-rls", "coc-spell-checker", "coc-sql", "coc-svg", "coc-swagger", "coc-texlab", "coc-toml", "coc-xml", "coc-yaml" ]

" tod: coc-prettier and coc-sh

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
set hidden " coc needs this or TextEdit can fail
set cmdheight=2 " for coc
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Mapping tab complete for coc
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh() " Space to trigger completion
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)


" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function',' ')}

noremap <silent> <leader>e :Fern . -drawer -toggle<CR>

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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



" C# settings
let g:OmniSharp_server_path = "/etc/profiles/per-user/wil/bin/omnisharp"


" Ale config
let g:ale_linters = { 'cs': ['OmniSharp'], 'nix': ['rnix_lsp'] }
let b:ale_linters = [ 'cs', 'nix' ]

let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\}


let g:fern#renderer = "nerdfont"
set noshowmode


let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }




" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


fun! TrimWhiteSpace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup WIL_AUG
  autocmd!
  autocmd BufWritePre * :call TrimWhiteSpace()
augroup END
