return {
	{
		"numToStr/Comment.nvim",
		event = "BufReadPre",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})

			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		branch = "canary",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				disable_italics = true,
			})
			-- vim.cmd.colorscheme("rose-pine")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = { enable = true },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		cmd = "Telescope",
		keys = {
			{
				"<leader>f",
				"<cmd>Telescope find_files find_command=fd,-t,f,-H,-E,.git,--strip-cwd-prefix theme=dropdown previewer=false<cr>",
				desc = "Find files",
			},
			{
				"<leader>/",
				"<cmd>Telescope live_grep<cr>",
				desc = "Find text",
			},
			{
				"<leader>p",
				"<cmd>Telescope commands theme=dropdown<cr>",
				desc = "Commands",
			},
		},
		config = true,
	},
	{
		"kyazdani42/nvim-tree.lua",
		keys = {
			{
				"<leader>e",
				"<cmd>NvimTreeFindFileToggle<cr>",
				desc = "Toggle file tree",
			},
		},
		opts = {
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			filters = {
				-- Hide ".git" folder.
				custom = { "^.git$" },
			},
			git = { ignore = false },
			renderer = {
				icons = {
					show = {
						file = false,
						folder = false,
						folder_arrow = false,
						git = false,
					},
				},
			},
			trash = { cmd = "trash" },
			view = {
				side = "right",
				mappings = {
					list = {
						{ key = "d", action = "trash" },
						{ key = "D", action = "remove" },
					},
				},
			},
		},
	},
}
