--- lil-ui.lua
--- https://github.com/mvllow/lilvim

--- Setup interface elements including colorscheme and statusline.

local use = require('lil-helpers').use

use({
	'nvim-treesitter/nvim-treesitter',
	run = ':TSUpdate',
	config = function()
		require('nvim-treesitter.configs').setup({
			ensure_installed = 'all',
			ignore_install = { 'phpdoc' },
			highlight = { enable = true },
		})
	end,
})
use({
	'rose-pine/neovim',
	as = 'rose-pine',
	config = function()
		require('rose-pine').setup({ disable_italics = true })
		vim.cmd('colorscheme rose-pine')
	end,
})

vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25

vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
vim.opt.statusline = ' %f %M %= %l:%c ♥ '
vim.opt.shortmess:append('c')

-- Equally resize splits
vim.api.nvim_create_autocmd('VimResized', {
	command = 'tabdo wincmd =',
})
