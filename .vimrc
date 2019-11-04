set packpath^=~/.vim
packadd minpac

call minpac#init()
call minpac#add('dense-analysis/ale')
call minpac#add('pangloss/vim-javascript')
call minpac#add('sheerun/vim-polyglot')
call minpac#add('/usr/local/opt/fzf')
call minpac#add('junegunn/fzf.vim')
set rtp+=/usr/local/opt/fzf

let g:jsx_ext_required = 0

let g:ale_linters = {
\  'javascript': ['eslint'],
\}
let g:ale_fixers = {
\  'javascript': ['eslint', 'prettier'],
\}
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '!'

highlight clear SignColumn
highlight clear ALEErrorSign
highlight clear ALEWarningSign

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

syntax off                             " Turn off syntax highlighting

set laststatus=0                       " Hide statusline
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

nnoremap <leader>f :FZF<cr>

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

