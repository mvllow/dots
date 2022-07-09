--- lil-editing.lua
--- https://github.com/mvllow/lilvim

--- Setup options related to editing.

local use = require('lil-helpers').use

use('editorconfig/editorconfig-vim')
use({
	'numToStr/Comment.nvim',
	config = function()
		require('comment').setup()
	end,
})

vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
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

local opts = { silent = true }
vim.keymap.set('i', 'jk', '<esc>', opts) -- alternative to <esc>
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opts) -- move through wrapped lines
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opts) -- move through wrapped lines
vim.keymap.set('v', '<', '<gv', opts) -- dedent (keep selection)
vim.keymap.set('v', '>', '>gv', opts) -- indent (keep selection)

-- Goto
vim.keymap.set('n', 'go', '<c-o>', opts) -- goto previous position
vim.keymap.set('n', 'gp', '<c-^>', opts) -- goto previously focused buffer
vim.keymap.set('n', 'gm', '%', opts) -- goto matching pair
vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, opts) -- goto previous diagnostic
vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, opts) -- goto next diagnostic
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts) -- goto line diagnostic message

-- Buffer
vim.keymap.set('n', '<leader>bp', ':bp<cr>', opts) -- focus previous buffer
vim.keymap.set('n', '<leader>bn', ':bn<cr>', opts) -- focus next buffer
vim.keymap.set('n', '<leader>bm', ':bm<cr>', opts) -- focus modified buffer
vim.keymap.set('n', '<leader>bd', ':bd<cr>', opts) -- delete buffer

-- Window
vim.keymap.set('n', '<leader>wh', '<c-w>h', opts) -- move to left window
vim.keymap.set('n', '<leader>wj', '<c-w>j', opts) -- move to below window
vim.keymap.set('n', '<leader>wk', '<c-w>k', opts) -- move to above window
vim.keymap.set('n', '<leader>wl', '<c-w>l', opts) -- move to right window
vim.keymap.set('n', '<leader>wr', '<c-w>r', opts) -- swap split positions
vim.keymap.set('n', '<leader>ws', '<c-w>s', opts) -- open horizontal split
vim.keymap.set('n', '<leader>wv', '<c-w>v', opts) -- open vertical split
vim.keymap.set('n', '<leader>ww', '<c-w>w', opts) -- focus next window
vim.keymap.set('n', '<leader>wc', '<c-w>c', opts) -- close current window
vim.keymap.set('n', '<leader>wo', ':only<cr>', opts) -- close other windows
