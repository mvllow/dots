vim.g.mapleader = " "
vim.g.rose_pine_palette = {
	light = {
		text = "#2a2a2a",
		love = "#b73a3a",
		pine = "#4a944a",
		gold = "#d18f00",
		foam = "#3566b8",
		iris = "#9e4bb5",
		rose = "#cc6f56",
	},
	dark = {
		text = "#e0e0e0",
		love = "#e05f5f",
		pine = "#5dc28b",
		gold = "#f2c94c",
		foam = "#5794f2",
		iris = "#c27ac8",
		rose = "#c49a9a",
	}
}
vim.cmd.colorscheme("rose-pine")

vim.o.undofile    = true
vim.o.tabstop     = 8
vim.o.shiftwidth  = 8
vim.o.pumheight   = 4
vim.o.scrolloff   = 3
vim.o.signcolumn  = "yes"
vim.o.breakindent = true
vim.o.linebreak   = true
vim.o.showbreak   = "↪"
vim.o.ignorecase  = true
vim.o.smartcase   = true
vim.o.spell       = true
vim.o.spelllang   = "en,it"

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })

vim.keymap.set({ "n", "v" }, "<c-j>", ":cnext<cr>")
vim.keymap.set({ "n", "v" }, "<c-k>", ":cprev<cr>")

vim.keymap.set("n", "*", "*N")
vim.keymap.set("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])

vim.keymap.set("n", "S", ":%s/<c-r><c-w>/<c-r><c-w>/g<left><left>")
vim.keymap.set("v", "S", [["zy:let @"=@0<cr>:%s/<c-r>z/<c-r>z/g<left><left>]])

vim.keymap.set("n", "<c-d>", vim.diagnostic.setqflist)
vim.keymap.set("n", "gl", vim.diagnostic.open_float)

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/mvllow/lilvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/vim-test/vim-test",
	"https://github.com/tpope/vim-sleuth",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/sschleemilch/slimline.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mistweaverco/kulala.nvim",
})

require("lil-lsp")
require("lil-grep")
require("lil-places")
require("lil-quickfix")
require("lil-subs")
require("lil-windows")

require("slimline").setup({
	bold = true,
	style = "fg",
	components = {
		left = { "mode", "path", "git" },
		center = { "recording" },
		right = { "diagnostics", "progress" },
	},
	configs = { progress = { column = true } },
	hl = {
		base = "StatusLine",
		primary = "StatusLine",
	},
})

require("mason").setup()
require("mason-lspconfig").setup()

require("mini.diff").setup()
require("mini.files").setup({ options = { permanent_delete = false } })
vim.keymap.set("n", "<leader>e", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "File explorer" })
local minipick = require("mini.pick")
local choose_all = function()
	local mappings = minipick.get_picker_opts().mappings
	vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
end

minipick.setup({ mappings = { choose_all = { char = "<c-q>", func = choose_all } } })

vim.ui.select = minipick.ui_select

vim.keymap.set("n", "<leader>f", ":Pick files<cr>", { desc = "Search files" })
vim.keymap.set("n", "<leader>/", ":Pick grep_live<cr>", { desc = "Search text" })
vim.keymap.set("n", "<leader>.", ":Pick resume<cr><space><bs>", { desc = "Resume search" })

-- vim-test
if vim.uv.fs_stat(vim.fn.getcwd() .. "/nx.json") then
	vim.g["test#javascript#runner"] = "nx"
end

require("conform").setup({
	notify_on_error = false,
	default_format_opts = { lsp_format = "fallback" },
	formatters_by_ft = {
		fish = { "fish_indent" },
		go = { "goimports" },
		sh = { "shfmt" },
		ruby = { "rubyfmt" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		vue = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		less = { "prettier" },
		html = { "prettier" },
		htmlangular = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		graphql = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
		astro = { "prettier" },
		svelte = { "prettier" },
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
	pattern = "*",
	callback = function()
		require("conform").format({ timeout_ms = 1000 })
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		vim.cmd("TSUpdate")
	end
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if not vim.tbl_contains(require("nvim-treesitter.config").get_available(), lang) then
			return
		end
		require("nvim-treesitter").install(lang):await(function()
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			pcall(vim.treesitter.start)
		end)
	end
})

-- npm install -g @mistweaverco/kulala-ls
vim.lsp.enable("kulala_ls")
require("kulala").setup({ global_keymaps = true })

-- brew install gleam
vim.lsp.enable("gleam")
