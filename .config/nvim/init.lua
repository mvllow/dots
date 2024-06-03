vim.g.mapleader = " "

vim.opt.guicursor = ""
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 3
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.pumheight = 5
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = [[\\]]

vim.api.nvim_create_autocmd("VimResized", { command = "tabdo wincmd =" })

vim.keymap.set("n", "]q", ":cnext<cr>zz")
vim.keymap.set("n", "[q", ":cprev<cr>zz")

local keys = {
	["cr"] = vim.api.nvim_replace_termcodes("<cr>", true, true, true),
	["ctrl-y"] = vim.api.nvim_replace_termcodes("<c-y>", true, true, true),
	["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<c-y><cr>", true, true, true),
}
vim.keymap.set("i", "<cr>", function()
	return vim.fn.pumvisible() ~= 0
			and (vim.fn.complete_info()["selected"] ~= 1 and keys["ctrl-y"] or keys["ctrl-y_cr"])
		or keys["cr"]
end, { expr = true })
vim.keymap.set("i", "<tab>", [[pumvisible() ? "\<c-n>" : "\<tab>"]], { expr = true })
vim.keymap.set("i", "<s-tab>", [[pumvisible() ? "\<c-p>" : "\<s-tab>"]], { expr = true })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set("n", "S", ":%s/<c-r><c-w>/<c-r><c-w>/g<left><left>")
vim.keymap.set("v", "S", [["zy:let @"=@0<cr>:%s/<c-r>z/<c-r>z/g<left><left>]])
vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "<c-h>", "<c-w>h")
vim.keymap.set({ "n", "v" }, "<c-j>", "<c-w>j")
vim.keymap.set({ "n", "v" }, "<c-k>", "<c-w>k")
vim.keymap.set({ "n", "v" }, "<c-l>", "<c-w>l")
vim.keymap.set({ "n", "v" }, "<c-,>", "<c-w>5<")
vim.keymap.set({ "n", "v" }, "<c-.>", "<c-w>5>")
vim.keymap.set({ "n", "v" }, "<c-=>", "<c-w>+")
vim.keymap.set({ "n", "v" }, "<c-->", "<c-w>-")
vim.keymap.set("n", "*", "*N")
vim.keymap.set("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])
vim.keymap.set("n", "<leader>cp", [[:let @+ = "./" . expand("%")<cr>]])
vim.keymap.set("n", "gl", vim.diagnostic.open_float)

vim.diagnostic.config({ virtual_text = false })

require("pam").manage({
	{ source = "tpope/vim-sleuth" },
	{ source = "tpope/vim-dadbod" },
	{ source = "kristijanhusak/vim-dadbod-ui" },
	{ source = "vim-test/vim-test" },
	{ source = "rose-pine/neovim" },
	{ source = "nvim-treesitter/nvim-treesitter" },
	{ source = "folke/ts-comments.nvim" },
	-- packadd mini.nvim | helptags ALL
	{ source = "echasnovski/mini.nvim" },
	{ source = "stevearc/conform.nvim" },
	{ source = "mvllow/matcha.nvim" },
	{ source = "neovim/nvim-lspconfig" },
	{ source = "williamboman/mason.nvim" },
	{ source = "williamboman/mason-lspconfig.nvim" },
	{
		source = "ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { { source = "nvim-lua/plenary.nvim" } },
	},
})

require("nvim-treesitter.configs").setup({
	auto_install = true,
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
	highlight = { enable = true, additional_vim_regex_highlighting = { "ruby" } },
	indent = { enable = true, disable = { "ruby" } },
})

require("ts-comments").setup()

require("rose-pine").setup({ styles = { italic = false } })
vim.cmd.colorscheme("rose-pine")

require("mini.completion").setup()

require("mini.diff").setup({ view = { signs = { add = "+", change = "~", delete = "-" } } })
vim.keymap.set("n", "]h", function()
	require("mini.diff").goto_hunk("next")
end)
vim.keymap.set("n", "[h", function()
	require("mini.diff").goto_hunk("prev")
end)

require("mini.doc").setup()

require("mini.files").setup()
vim.keymap.set("n", "<leader>e", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0))
end)

local choose_all = function()
	local mappings = MiniPick.get_picker_opts().mappings
	vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
end
require("mini.pick").setup({
	mappings = {
		choose_all = { char = "<C-q>", func = choose_all },
	},
})
vim.ui.select = require("mini.pick").ui_select
vim.keymap.set("n", "<leader>f", ":Pick files<cr>")
vim.keymap.set("n", "<leader>.", function()
	MiniPick.refresh()
	MiniPick.builtin.resume()
	MiniPick.refresh()
	-- ":Pick resume<cr><space><bs>"
end)
vim.keymap.set("n", "<leader>/", ":Pick grep_live<cr>")

require("mini.test").setup()

local harpoon = require("harpoon")
harpoon:setup({ settings = { save_on_toggle = true } })
vim.keymap.set("n", "ma", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<leader>m", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set("n", "'a", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "'s", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "'d", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "'f", function()
	harpoon:list():select(4)
end)
vim.keymap.set("n", "'g", function()
	harpoon:list():select(5)
end)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("CustomLspAttach", { clear = true }),
	callback = function(event)
		vim.b.minicompletion_config = { lsp_completion = { source_func = "omnifunc", auto_setup = false } }
		vim.api.nvim_set_option_value("omnifunc", "v:lua.MiniCompletion.completefunc_lsp", { buf = event.buf })
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local servers = {
	angularls = require("linguine.languages.angular").lspconfig(),
	lua_ls = require("linguine.languages.lua").lspconfig(),
}

require("mason").setup()
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			server.capabilities = capabilities
			require("lspconfig")[server_name].setup(server)
		end,
	},
})

require("conform").setup({
	notify_on_error = false,
	default_format_opts = { lsp_format = "fallback" },
	formatters_by_ft = vim.tbl_extend("force", {
		fish = { "fish_indent" },
		go = { "goimports" },
		lua = { "stylua" },
	}, require("linguine.formatters.prettier")),
})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
	pattern = "*",
	callback = function()
		require("conform").format()
	end,
})

require("matcha").setup({
	prefix = ",",
	keys = {
		a = "matcha_copilot",
		b = "background",
		c = "cmdheight",
		d = "matcha_diagnostics",
		f = "FormatOnSave",
		g = "matcha_diff_overlay",
		h = "matcha_inlay_hints",
		l = "list",
		m = "laststatus",
		q = "matcha_quickfix",
		s = "spell",
		w = "wrap",
	},
})

-- kristijanhusak/vim-dadbod-ui
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_save_location = "~/.local/share/db_ui"
vim.g.db_ui_tmp_query_location = "~/.local/share/db_ui/tmp"
vim.keymap.set("n", "<leader>W", "<plug>(DBUI_SaveQuery)")

-- vim-test/vim-test
-- https://github.com/vim-test/vim-test/issues/776
-- vim.g["test#strategy"] = "dispatch"
vim.g["test#strategy"] = "neovim"
vim.keymap.set("n", "<leader>tf", ":TestFile<cr>")
vim.keymap.set("n", "<leader>tn", ":TestNearest<cr>")
