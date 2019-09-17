set packpath^=~/.vim
packadd minpac

call minpac#init()
call minpac#add('arcticicestudio/nord-vim')
call minpac#add('burner/vim-svelte')
call minpac#add('fatih/vim-go')
call minpac#add('itchyny/lightline.vim')
call minpac#add('junegunn/fzf', { 'do': './install --all' })
call minpac#add('junegunn/fzf.vim')
call minpac#add('mxw/vim-jsx')
call minpac#add('pangloss/vim-javascript')
call minpac#add('sheerun/vim-polyglot')
call minpac#add('w0rp/ale')

" ALE linter
let g:ale_fix_on_save = 1
let g:ale_fixers = { 'javascript': ['eslint', 'prettier'], 'svelte': ['eslint', 'prettier'] }
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_linter_aliases = {'svelte': ['css', 'javascript']}
let g:ale_linters = { 'javascript': ['eslint', 'prettier'], 'svelte': ['eslint', 'prettier'] }
let g:ale_sign_error = '✖'

" Golang
let g:go_doc_keywordprg_enabled = 0

" FZF
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

syntax on
set noshowmode
set laststatus=2
set signcolumn=yes
hi SignColumn ctermbg=black
hi SignColumn ctermbg=NONE
let g:lightline = { 'colorscheme': 'nord' }
colorscheme nord

set hidden

" natural splits
set splitbelow
set splitright

set noswapfile
set viminfo=""
set undofile
set undodir=~/.vim/undo

set ignorecase
set smartcase

set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

let mapleader=','

inoremap jk <esc>

nnoremap J 5j
nnoremap K 5k
nnoremap j gj
nnoremap k gk

nnoremap <silent> <leader>s :bnext<cr>
nnoremap <silent> <leader>a :bprev<cr>
nnoremap <silent> <leader>d :bd<cr>

nnoremap <leader>f :FZF<cr>

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
