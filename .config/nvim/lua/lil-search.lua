--- lil-search.lua
--- https://github.com/mvllow/lilvim

--- Setup search.

local use = require('lil-helpers').use

use({
	'nvim-telescope/telescope.nvim',
	config = function()
		require('telescope').setup({
			defaults = {
				layout_config = {
					horizontal = {
						-- Increase preview width
						preview_width = 0.6,
					},
				},
			},
			pickers = {
				find_files = {
					theme = 'dropdown',
					previewer = false,
					find_command = { 'fd', '-t', 'f', '--strip-cwd-prefix' },
				},
			},
		})
	end,
})

vim.opt.ignorecase = true
vim.opt.smartcase = true

local opts = { silent = true }
vim.keymap.set('n', '<esc>', ':noh<cr>', opts) -- clear search highlights
vim.keymap.set('n', '*', '*N', opts) -- search word under cursor (keep position)
vim.keymap.set('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], opts) -- search selection (keep position)
vim.keymap.set('n', '<leader>f', ':Telescope find_files<cr>', opts)
vim.keymap.set('n', '<leader>/', ':Telescope live_grep<cr>', opts)
