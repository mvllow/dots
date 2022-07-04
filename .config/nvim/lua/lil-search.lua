--- lil-search.lua
--- https://github.com/mvllow/lilvim

--- Setup search.

local use = require('lil-helpers').use
local map = require('lil-helpers').map

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
		})
	end,
})

vim.opt.ignorecase = true
vim.opt.smartcase = true

map('n', '<esc>', ':noh<cr>', 'clear search highlights')
map('n', '*', '*N', 'search word under cursor')
map('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], 'search selection')
map('n', 'S', ':%s///g<left><left>', 'substitute search')

map('n', '<leader>/', ':Telescope live_grep<cr>')
map(
	'n',
	'<leader>f',
	':Telescope find_files find_command=fd,-t,f,-H,-E,.git,--strip-cwd-prefix theme=dropdown previewer=false<cr>'
)
map('n', '<leader>p', ':Telescope commands theme=dropdown<cr>')
