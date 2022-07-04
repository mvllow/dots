--- lil-editing.lua
--- https://github.com/mvllow/lilvim

--- Setup options related to editing.

local use = require('lil-helpers').use
local map = require('lil-helpers').map

use('editorconfig/editorconfig-vim')
use({
	'numToStr/Comment.nvim',
	config = function()
		require('comment').setup()
	end,
})

vim.opt.mouse = 'a'
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.undofile = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.breakindent = true

-- Stop 'o' continuing comments
vim.api.nvim_create_autocmd('BufEnter', {
	command = 'setlocal formatoptions-=o',
})

vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
})

map('i', 'jk', '<esc>')
map({ 'n', 'v' }, 'j', 'gj', 'move through wrapped lines')
map({ 'n', 'v' }, 'k', 'gk', 'move through wrapped lines')
map('v', '<', '<gv', 'dedent (keep selection)')
map('v', '>', '>gv', 'indent (keep selection)')

-- Goto
map('n', 'go', '<c-o>', 'goto previous position')
map('n', 'gp', '<c-^>', 'goto previously focused buffer')
map('n', 'gm', '%', 'goto matching pair')
map('n', 'g[', vim.diagnostic.goto_prev, {
	desc = 'goto previous diagnostic',
})
map('n', 'g]', vim.diagnostic.goto_next, {
	desc = 'goto next diagnostic',
})
map('n', 'gl', vim.diagnostic.open_float, {
	desc = 'goto line diagnostic message',
})

-- Buffer
map('n', '<leader>bp', ':bp<cr>', 'focus previous buffer')
map('n', '<leader>bn', ':bn<cr>', 'focus next buffer')
map('n', '<leader>bm', ':bm<cr>', 'focus modified buffer')
map('n', '<leader>bd', ':bd<cr>', 'delete buffer')

-- Window
map('n', '<leader>wh', '<c-w>h', 'move to left split')
map('n', '<leader>wj', '<c-w>j', 'move to below split')
map('n', '<leader>wk', '<c-w>k', 'move to above split')
map('n', '<leader>wl', '<c-w>l', 'move to right split')
map('n', '<leader>wr', '<c-w>r', 'swap split positions')
map('n', '<leader>ws', '<c-w>s', 'open horizontal split')
map('n', '<leader>wv', '<c-w>v', 'open vertical split')
map('n', '<leader>ww', '<c-w>w', 'focus next window')
map('n', '<leader>wc', '<c-w>c', 'close current window')
map('n', '<leader>wo', ':only<cr>', 'close other windows')
