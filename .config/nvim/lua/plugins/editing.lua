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
		"echasnovski/mini.align",
		event = "BufReadPre",
		config = function()
			require("mini.align").setup()
		end,
	},
}
