" Generated by mvllow/dots

set packpath^=~/.vim
packadd minpac

call minpac#init()
call minpac#add('arcticicestudio/nord-vim')
call minpac#add('burner/vim-svelte')
call minpac#add('itchyny/lightline.vim')
call minpac#add('junegunn/fzf', { 'do': './install --all' })
call minpac#add('junegunn/fzf.vim')
call minpac#add('mxw/vim-jsx')
call minpac#add('pangloss/vim-javascript')
call minpac#add('sheerun/vim-polyglot')
call minpac#add('w0rp/ale')

let mapleader=','

" ALE
"
" Lint and fix javascript/svelte/prettier-supported langs
"
let g:ale_fix_on_save = 1
let g:ale_fixers = { 'javascript': ['eslint', 'prettier'], 'svelte': ['eslint', 'prettier'] }
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_linter_aliases = {'svelte': ['css', 'javascript']}
let g:ale_linters = { 'javascript': ['eslint', 'prettier'], 'svelte': ['eslint', 'prettier'] }
let g:ale_sign_error = '✖'

" Appearance
" 
" Attemps to set transparent sign column, fallback to black
"
syntax on
set noshowmode
set laststatus=2
set signcolumn=yes
hi SignColumn ctermbg=black
hi SignColumn ctermbg=NONE
let g:lightline = { 'colorscheme': 'nord' }
colorscheme nord

" Splits
"
" splitbelow | Default vertical split to below (vs above)
" splitright | Default horizontal split to right (vs left)
set splitbelow
set splitright

" Vim files
"
" noswapfile | Do not create swap files
" viminfo    | Do not create ~/.viminfo
" undofile   | Enable persistent undo...
" undodir    | ...and save states in ~/.vim/undo
"
set noswapfile
set viminfo=""
set undofile
set undodir=~/.vim/undo

" Tabs and spacing
"
" tabstop     | Amount of indentation per tab byte 
" shiftwidth  | Same as tabstop except when manually indenting via `>>`
" expandtab   | Prefer spaces over tabs
" autoindent  | Auto indent on new lines or where otherwise appropriate
" smartindent | Same as autoindent except reacts to current syntax/style
"
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

" Search
"
" ignorecase       | Case insensitive search...
" smartcase        | ...unless using uppercase
"
" <leader>f -> FZF | open FZF menu
set ignorecase
set smartcase

let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nnoremap <leader>f :FZF<cr>

" Movements
"
" jk -> esc         | Exit insert mode
"  J -> 5j, K -> 5k | Move up or down by 5 lines
"  j -> gj, k -> gk | Natural vertical movement through wrapped lines
"
inoremap jk <esc>
nnoremap J 5j
nnoremap K 5k
nnoremap j gj
nnoremap k gk

" Buffer manipulation
" 
" hidden               | Allow unsaved hidden buffers
" <leader>s -> bnext   | Focus next buffer
" <leader>a -> bprev   | Focus previous buffer
" <leader>d -> bdelete | Close current buffer
"
set hidden
nnoremap <silent> <leader>s :bnext<cr>
nnoremap <silent> <leader>a :bprev<cr>
nnoremap <silent> <leader>d :bd<cr>

" Minpac plugin manager
"
" PackUpdate | Install and update plugins
" PackClean  | Remove unused plugins
" PackStatus | Show plugin status
"
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
