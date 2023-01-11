return {
	"echasnovski/mini.completion",
	event = "BufReadPre",
	keys = {
		{
			"<cr>",
			function()
				local keys = {
					["cr"] = vim.api.nvim_replace_termcodes("<cr>", true, true, true),
					["c-y"] = vim.api.nvim_replace_termcodes("<c-y>", true, true, true),
					["c-y_cr"] = vim.api.nvim_replace_termcodes("<c-y><cr>", true, true, true),
				}

				if vim.fn.pumvisible() ~= 0 then
					local item_selected = vim.fn.complete_info()["selected"] ~= -1
					return item_selected and keys["c-y"] or keys["c-y_cr"]
				else
					return keys["cr"]
				end
			end,
			mode = "i",
			expr = true,
		},
		{ "<tab>", "pumvisible() ? '<c-n>' : '<tab>'", mode = "i", expr = true },
		{ "<s-tab>", "pumvisible() ? '<c-p>' : '<s-tab>'", mode = "i", expr = true },
	},
	config = function()
		require("mini.completion").setup({})
	end,
}
