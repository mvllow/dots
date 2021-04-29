local set_keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

set_keymap('n', '<space>', '<nop>', opts)
vim.g.mapleader = ' '

-- simplify split movements
set_keymap('n', '<c-h>', '<c-w><c-h>', opts)
set_keymap('n', '<c-j>', '<c-w><c-j>', opts)
set_keymap('n', '<c-k>', '<c-w><c-k>', opts)
set_keymap('n', '<c-l>', '<c-w><c-l>', opts)

-- move through wrapped lines
set_keymap('n', 'j', 'gj', opts)
set_keymap('n', 'k', 'gk', opts)

-- toggle word highlight
set_keymap('n', '<leader>h', ':set hlsearch!<cr>', opts)

-- switch buffers
set_keymap('n', '}', ':bnext<cr>', opts)
set_keymap('n', '{', ':bprevious<cr>', opts)

-- reselect after visual indent
set_keymap('v', '<', '<gv', opts)
set_keymap('v', '>', '>gv', opts)

-- search visually selected text (consistent `*` behaviour)
set_keymap('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>]], opts)

-- bubble lines
set_keymap('x', 'J', ':move \'>+1<cr>gv=gv', opts)
set_keymap('x', 'K', ':move \'<-2<cr>gv=gv', opts)

-- escape
set_keymap('i', 'jk', '<esc>', opts)

