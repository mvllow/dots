syntax off

set rtp+=/usr/local/opt/fzf            " Use local fzf
set laststatus=0                       " Hide status line
set splitbelow                         " Split vertical below
set splitright                         " Split horizontal right
set noswapfile                         " Do not create swap files
set viminfo=""                         " Do not create ~/.viminfo
set undofile                           " Enable persistent undo...
set undodir=~/.vim/undo                " ...and save state in ~/.vim/undo
set tabstop=2                          " Amount of indentation per tab byte
set shiftwidth=2                       " Same as tabstop but for indenting via `>>`
set expandtab                          " Prefer spaces over tabs
set autoindent                         " Auto indent new lines
set smartindent                        " Same as autoindent but for current syntax/style
set ignorecase                         " Case insensitive search...
set smartcase                          " ...unless using uppercase
set hidden                             " Allow unsaved hidden buffers
set autowrite                          " Auto save changes before switching buffer

let mapleader=','

inoremap jk <esc>

nnoremap K 5gk
nnoremap J 5gj
nnoremap k gk
nnoremap j gj

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>f :FZF<cr>
