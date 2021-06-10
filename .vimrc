syntax off

filetype indent on
set autoindent expandtab
set shiftwidth=2 softtabstop=2 tabstop=2

set hlsearch ignorecase incsearch smartcase

set nobackup noswapfile nowritebackup
set undofile undodir=~/.vim/undo undolevels=9999
set viminfo=""

set hidden
set laststatus=1
set splitbelow splitright

let mapleader=' '
nnoremap <space> <nop>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap k gk
nnoremap j gj
inoremap jk <esc>