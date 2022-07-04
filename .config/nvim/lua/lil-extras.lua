--- lil-extras.lua
--- https://github.com/mvllow/lilvim

--- Setup not so lil enhancements. This includes plugins to replace or improve
--- built-in functionality.

local use = require('lil-helpers').use
local map = require('lil-helpers').map

use({
	'kyazdani42/nvim-tree.lua',
	config = function()
		require('nvim-tree').setup({
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			filters = {
				-- Hide ".git" folder
				custom = { '.git$' },
			},
			git = {
				-- Do not hide gitignored files
				ignore = false,
			},
			renderer = {
				icons = {
					-- Do not show tree icons
					show = {
						file = false,
						folder = false,
						folder_arrow = false,
						git = false,
					},
				},
			},
			trash = {
				cmd = 'trash',
			},
			view = {
				mappings = {
					list = {
						-- Replace destructive default with trash program
						-- E.g. https://github.com/sindresorhus/trash-cli
						{ key = 'd', action = 'trash' },
						{ key = 'D', action = 'remove' },
					},
				},
				side = 'right',
			},
		})
	end,
})

map('n', '<leader>e', ':NvimTreeFindFileToggle<cr>')
