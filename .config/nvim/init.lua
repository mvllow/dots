vim.g.mapleader = " "

vim.g.linen_groups = {
	Normal = { bg = "NONE" },
	MiniPickPrompt = { bg = vim.o.winborder == "none" and "surface" or "base", fg = "magenta" },
}
vim.cmd.colorscheme("linen")

vim.o.guicursor = ""
vim.o.pumheight = 4
vim.o.scrolloff = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.showbreak = [[\\]]
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.spell = true
vim.o.spelllang = "en,it"
vim.o.winborder = "rounded"

vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.o.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })

-- Navigate between wrapped lines
vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })

-- Navigate quickfix list
vim.keymap.set("n", "<c-j>", "]q", { remap = true })
vim.keymap.set("n", "<c-k>", "[q", { remap = true })

-- Yank and paste via clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

-- Override "*" to visualise current word or selection
vim.keymap.set("n", "*", "*N")
vim.keymap.set("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])

-- Override "S" to substitute current word or selection
vim.keymap.set("n", "S", ":%s/<c-r><c-w>/<c-r><c-w>/g<left><left>")
vim.keymap.set("v", "S", [["zy:let @"=@0<cr>:%s/<c-r>z/<c-r>z/g<left><left>]])

-- Diagnostics
vim.keymap.set("n", "<c-d>", vim.diagnostic.setqflist)
vim.keymap.set("n", "gl", vim.diagnostic.open_float)

vim.api.nvim_create_autocmd("VimResized", { command = "tabdo wincmd =" })

local pam_path = vim.fn.stdpath("data") .. "/site/pack/pam/start/pam.nvim"
if not vim.uv.fs_stat(pam_path) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/mvllow/pam.nvim", pam_path })
	vim.cmd("packadd pam.nvim")
end

require("pam").manage({
	{ source = "mvllow/pam.nvim" },
	{
		source = "nvim-treesitter/nvim-treesitter",
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				ensure_installed = { "c", "lua", "markdown", "markdown_inline", "vim", "vimdoc" },
				highlight = { enable = true },
			})
		end
	},
	{
		source = "echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup()
			-- require("mini.diff").setup({ view = { signs = { add = "+", change = "~", delete = "-" } } })
			require("mini.diff").setup()
			require("mini.files").setup({ options = { permanent_delete = false } })
			vim.keymap.set("n", "<leader>e", function()
				require("mini.files").open(vim.api.nvim_buf_get_name(0))
			end)

			local minipick = require("mini.pick")
			local choose_all = function()
				local mappings = minipick.get_picker_opts().mappings
				vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
			end
			minipick.setup({ mappings = { choose_all = { char = "<c-q>", func = choose_all } } })
			vim.ui.select = minipick.ui_select
			vim.keymap.set("n", "<leader>f", ":Pick files<cr>")
			vim.keymap.set("n", "<leader>/", ":Pick grep_live<cr>")
			vim.keymap.set("n", "<leader>.", ":Pick resume<cr><space><bs>")
		end
	},
	{ source = "neovim/nvim-lspconfig" },
	{
		source = "stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				notify_on_error = false,
				default_format_opts = { lsp_format = "fallback" },
				formatters_by_ft = {
					fish = { "fish_indent" },
					go = { "goimports" },
					sh = { "shfmt" },
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

			vim.keymap.set("n", "gq", function()
				vim.lsp.buf.format()
				-- Workaround for diagnostics disappearing when formatting with no changes
				-- https://github.com/neovim/neovim/issues/25013
				vim.diagnostic.enable()
			end)

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
				pattern = "*",
				callback = function()
					require("conform").format({ timeout_ms = 1000 })
				end,
			})
		end,
	},
	{
		source = "vim-test/vim-test",
		config = function()
			if vim.uv.fs_stat(vim.fn.getcwd() .. "/nx.json") then
				vim.g["test#javascript#runner"] = "nx"
			end

			vim.keymap.set("n", "<leader>tf", ":TestFile<cr>")
			vim.keymap.set("n", "<leader>tn", ":TestNearest<cr>")
		end,
	},
	{
		source = "kristijanhusak/vim-dadbod-ui",
		dependencies = { { source = "tpope/vim-dadbod" } },
		config = function()
			vim.g.db_ui_save_location = "~/.local/share/db_ui"
			vim.g.db_ui_tmp_query_location = "~/.local/share/db_ui/tmp"
			vim.keymap.set("n", "<leader>W", "<plug>(DBUI_SaveQuery)")
		end,
	},
	{
		source = "mvllow/supplement.nvim",
		config = function()
			require("supplement").setup()
		end
	},
	{
		source = "mvllow/matcha.nvim",
		branch = "canary",
		config = function()
			require("matcha").setup({ prefix = "," })
		end
	},
})

require("lil-entities")
require("lil-grep")
require("lil-lsp")

require("lil-places")
vim.keymap.set("n", "<leader>m", ":LilPlaces<cr>")

require("lil-quickfix")
