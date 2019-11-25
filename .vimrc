if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'Yggdroot/indentLine'
Plug 'junegunn/goyo.vim'
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'terryma/vim-multiple-cursors'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

syntax off

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

set rtp+=/usr/local/opt/fzf

let g:indentLine_char = '¦'

let g:goyo_width = 120

let g:ale_linters = {
\  'javascript': ['eslint'],
\  'javascriptreact': ['eslint'],
\  'typescript': ['eslint'],
\  'typescriptreact': ['eslint'],
\  'svelte': ['eslint']
\}
let g:ale_linter_aliases = {
\  'svelte': ['css', 'javascript']
\}
let g:ale_fixers = {
\  'javascript': ['eslint', 'prettier'],
\  'javascriptreact': ['eslint', 'prettier'],
\  'typescript': ['eslint', 'prettier'],
\  'typescriptreact': ['eslint', 'prettier'],
\  'svelte': ['eslint', 'prettier']
\}
let g:ale_lint_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '!'

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 15

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

highlight clear ALEErrorSign
highlight clear ALEWarningSign
highlight clear SignColumn

set number
set laststatus=2 " For lightline
set noshowmode

set formatoptions-=o " Stop comments when going to new line via "o" or "O"

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

let mapleader=','                      " Sets the <leader> character

inoremap jk <esc>

" Improve movement
" > Vertical movements will stay in current column
" > Adds optionn for J and K to move vertically by 5
nnoremap K 5gk
nnoremap J 5gj
nnoremap k gk
nnoremap j gj

nnoremap <silent> <leader>s :bnext<cr>
nnoremap <silent> <leader>a :bprev<cr>
nnoremap <silent> <leader>d :bd<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>f :FZF<cr>
nnoremap <leader><space> :ALEHover<cr>
nnoremap <leader>z :Goyo<cr>
nnoremap <leader>b :Lexplore<cr>

