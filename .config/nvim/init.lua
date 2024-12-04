vim.g.mapleader = " "

vim.o.guicursor = ""
vim.o.signcolumn = "yes"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.pumheight = 5
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.showbreak = [[\\]]
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.lazyredraw = true

-- Navigate between wrapped lines
vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })

-- Navigate quickfix results
vim.keymap.set("n", "<c-j>", ":cnext<cr>zz")
vim.keymap.set("n", "<c-k>", ":cprev<cr>zz")

-- Use tab to navigate popup menu, enter to confirm selection
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

-- Yank and paste via clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

-- Override "*" to visualise current word or selection
vim.keymap.set("n", "*", "*N")
vim.keymap.set("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])

-- Override "S" to substitute current word or selection
vim.keymap.set("n", "S", ":%s/<c-r><c-w>/<c-r><c-w>/g<left><left>")
vim.keymap.set("v", "S", [["zy:let @"=@0<cr>:%s/<c-r>z/<c-r>z/g<left><left>]])

vim.keymap.set("n", "<leader>e", ":Ex<cr>")

-- Show diagnostic message
vim.keymap.set("n", "gl", vim.diagnostic.open_float)

if vim.fn.executable("fzf") ~= 0 then
	vim.opt.runtimepath:append("/opt/homebrew/opt/fzf")
	vim.keymap.set("n", "<leader>f", ":FZF<cr>")
end

if vim.fn.executable("rg") ~= 0 then
	-- Use `:grep some-text` to search, then `:copen` to open quickfix list
	vim.o.grepprg = "rg --vimgrep"
end

-- Balance windows on resize
vim.api.nvim_create_autocmd("VimResized", { command = "tabdo wincmd =" })

vim.diagnostic.config({
	signs = false,
	virtual_text = false,
})

vim.filetype.add(require("linguine.filetypes"))

require("pam").manage({
	{ source = "mvllow/pam.nvim" },
	{
		source = "williamboman/mason.nvim",
		dependencies = {
			{ source = "neovim/nvim-lspconfig" },
			{ source = "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			local languages = require("linguine.languages")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local servers = {
				angularls = languages.angular.lspconfig(),
				lua_ls = languages.lua.lspconfig(),
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

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("CustomLspAttach", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					if client and languages[client.name] then
						languages[client.name].lsp_on_attach(client)
					end

					vim.b.minicompletion_config = { lsp_completion = { source_func = "omnifunc", auto_setup = false } }
					vim.api.nvim_set_option_value(
						"omnifunc",
						"v:lua.MiniCompletion.completefunc_lsp",
						{ buf = args.buf }
					)
				end,
			})
		end,
	},
	{
		source = "nvim-treesitter/nvim-treesitter",
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				ensure_installed = { "c", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc" },
				highlight = { enable = true, additional_vim_regex_highlighting = { "ruby" } },
				indent = { enable = false, disable = { "ruby" } },
			})
		end,
	},
	{
		source = "folke/ts-comments.nvim",
		config = function()
			require("ts-comments").setup()
		end,
	},
	{
		source = "rose-pine/neovim",
		config = function()
			require("rose-pine").setup({
				styles = { italic = false },
				highlight_groups = {
					CurSearch = { fg = "base", bg = "rose", inherit = false },
					Search = { fg = "text", bg = "rose", blend = 20, inherit = false },
					StatusLine = { fg = "base", bg = "text", inherit = false },
					Visual = { bg = "iris", blend = 15 },
					["@constant"] = { fg = "text", bold = true },
					["@variable.builtin"] = { fg = "text", bold = true },
				},
			})
			vim.cmd.colorscheme("rose-pine")
		end,
	},
	{
		source = "echasnovski/mini.nvim",
		config = function()
			require("mini.align").setup()

			require("mini.clue").setup()

			require("mini.completion").setup()

			local minidiff = require("mini.diff")
			minidiff.setup({ view = { signs = { add = "+", change = "~", delete = "-" } } })

			require("mini.doc").setup()

			local miniextra = require("mini.extra")
			miniextra.setup()

			local minifiles = require("mini.files")
			minifiles.setup()
			vim.keymap.set("n", "<leader>e", function()
				minifiles.open(vim.api.nvim_buf_get_name(0))
			end)

			require("mini.git").setup()

			local minipick = require("mini.pick")
			local choose_all = function()
				local mappings = minipick.get_picker_opts().mappings
				vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
			end
			minipick.setup({ mappings = { choose_all = { char = "<c-q>", func = choose_all } } })
			vim.ui.select = minipick.ui_select
			vim.keymap.set("n", "<leader>f", ":Pick files<cr>")
			vim.keymap.set("n", "<leader>.", ":Pick resume<cr><space><bs>")
			vim.keymap.set("n", "<leader>/", ":Pick grep_live<cr>")
			vim.keymap.set("n", "<leader>g", function()
				miniextra.pickers.git_files({ scope = "modified" })
			end)
			vim.keymap.set("n", "<leader>d", function()
				miniextra.pickers.diagnostic()
			end)
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
		source = "vim-test/vim-test",
		dependencies = { { source = "benmills/vimux" } },
		config = function()
			vim.g["test#strategy"] = "vimux"
			if vim.uv.fs_stat(vim.fn.getcwd() .. "/nx.json") then
				vim.g["test#javascript#runner"] = "nx"
			end

			vim.keymap.set("n", "<leader>tf", ":TestFile<cr>")
			vim.keymap.set("n", "<leader>tn", ":TestNearest<cr>")
			vim.keymap.set("n", "<leader>tq", ":VimuxCloseRunner<cr>")
			vim.keymap.set("n", "<leader>tz", ":VimuxZoomRunner<cr>")
		end,
	},
	{
		source = "ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { { source = "nvim-lua/plenary.nvim" } },
		config = function()
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
		end,
	},
	{
		source = "stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				notify_on_error = false,
				default_format_opts = { lsp_format = "fallback" },
				formatters_by_ft = require("linguine.formatters"),
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
				pattern = "*",
				callback = function()
					require("conform").format()
				end,
			})
		end,
	},
	{
		source = "mvllow/matcha.nvim",
		config = function()
			local prefix = ","
			require("matcha").setup({
				prefix = prefix,
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
					-- t = "matcha_terminal",
					w = "wrap",
					["-"] = "Supplement",
				},
			})

			vim.keymap.set("n", prefix .. "-", function()
				require("matcha").toggle("Supplement")
				require("Supplement").clear()
			end)
		end,
	},
	{
		source = "~/.config/nvim/lua/supplement",
		config = function()
			require("supplement").setup()
		end,
	},
})
