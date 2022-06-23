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
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.undofile = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.breakindent = true

local opts = { silent = true }
vim.keymap.set('i', 'jk', '<esc>', opts) -- escape alternative
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opts) -- move through wrapped lines
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opts) -- move through wrapped lines
vim.keymap.set('v', '<', '<gv', opts) -- dedent (keep selection)
vim.keymap.set('v', '>', '>gv', opts) -- indent (keep selection)
vim.keymap.set({ 'n', 'v' }, '<leader>l', ':normal gq80l<cr>', opts) -- wrap lines at column 80, respecting word breaks

-- Goto
vim.keymap.set('n', 'go', '<c-o>', opts) -- goto previous position

-- Window
vim.keymap.set('n', '<leader>wh', '<c-w><c-h>', opts) -- jump to split to the left
vim.keymap.set('n', '<leader>wj', '<c-w><c-j>', opts) -- jump to split below
vim.keymap.set('n', '<leader>wk', '<c-w><c-k>', opts) -- jump to split above
vim.keymap.set('n', '<leader>wl', '<c-w><c-l>', opts) -- jump to split to the right
vim.keymap.set('n', '<leader>wr', '<c-w><c-r>', opts) -- swap split positions
vim.keymap.set('n', '<leader>ww', '<c-w><c-w>', opts) -- focus next window
vim.keymap.set('n', '<leader>wo', ':only<cr>', opts) -- close other windows
vim.keymap.set('n', '<leader>e', ':Lex!<cr>', opts) -- toggle file explorer

-- Stop 'o' continuing comments
vim.api.nvim_create_autocmd('BufEnter', {
	command = 'setlocal formatoptions-=o',
})

vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
})
