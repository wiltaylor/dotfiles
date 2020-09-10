" __          ___ _   _______          _
" \ \        / (_) | |__   __|        | |
"  \ \  /\  / / _| |    | | __ _ _   _| | ___  _ __
"   \ \/  \/ / | | |    | |/ _` | | | | |/ _ \| '__|
"    \  /\  /  | | |    | | (_| | |_| | | (_) | |
"     \/  \/   |_|_|    |_|\__,_|\__, |_|\___/|_|
"                                 __/ |
"                                |___/
" Web: https://wil.dev
" Github: https://github.com/wiltaylor
" Contact: web@wiltaylor.dev
" Feel free to use this configuration as you wish.

"Basic editor config
set clipboard+=unnamedplus
set mouse=a
set encoding=utf-8
set number
set noswapfile
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Plugins
call plug#begin(stdpath('data') . '/plugged')
" Project panel on the side
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
call plug#end()

"Colour theme
colorscheme nord
let g:lightline = { 'colorscheme': 'nord', }

"Nerd tree config
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
