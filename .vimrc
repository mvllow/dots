syntax off

" Disable audio bell
set visualbell

" Use local fzf for fuzzy search
set rtp+=/usr/local/opt/fzf

" 2 spaces over tabs
filetype indent on
set autoindent expandtab
set shiftwidth=2 softtabstop=2 tabstop=2

" Highlight search, case insensitive unless uppercase
set hlsearch ignorecase incsearch smartcase

" No backups, persistent undo
set nobackup noswapfile nowritebackup
set undofile undodir=~/.vim/undo undolevels=9999
set viminfo=""

" Improve performance
set lazyredraw
set nocursorline
set ttyfast

" Buffers
set autoread
set hidden
set nowrap
set scrolloff=3
set splitbelow splitright

let mapleader=' '
nnoremap <space> <nop>

nnoremap <leader><leader>j :sp<cr>
nnoremap <leader><leader>l :vsp<cr>

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

nnoremap k gk
nnoremap j gj

nmap <leader>bd :bd<cr>
nmap <leader>bn :bn<cr>
nmap <leader>bp :bp<cr>

nnoremap <leader>f :FZF<cr>

inoremap jk <esc>
