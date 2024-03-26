local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

vim.opt.guicursor = ""

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = [[\\]]

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.pumheight = 5
vim.opt.scrolloff = 5

vim.opt.updatetime = 250

vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set("n", "<esc>", "<cmd>noh<cr>", { silent = true })
vim.keymap.set("n", "*", "*N")
vim.keymap.set("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])
vim.keymap.set("n", "<c-j>", ":cnext<cr>zz")
vim.keymap.set("n", "<c-k>", ":cprev<cr>zz")
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set("n", "S", ":%s/<c-r><c-w>//g<left><left>")
vim.keymap.set("n", "<leader>e", vim.cmd.Explore)
vim.keymap.set("n", "gl", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "⏺",
			[vim.diagnostic.severity.WARN] = "⏺",
			[vim.diagnostic.severity.INFO] = "⏺",
			[vim.diagnostic.severity.HINT] = "⏺",
		},
	},
	virtual_text = {
		prefix = "*",
	},
})

vim.api.nvim_create_autocmd("VimResized", {
	desc = "Balance windows",
	command = "tabdo wincmd =",
})

require("lazy").setup({
	"tpope/vim-rails",
	"tpope/vim-sleuth",
	"tpope/vim-commentary",
	"JoosepAlviste/nvim-ts-context-commentstring",
	"github/copilot.vim",
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			worktrees = { { toplevel = vim.env.HOME, gitdir = vim.env.HOME .. "dots.git" } },
		},
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })

			require("mini.surround").setup()

			require("mini.statusline").setup({
				use_icons = false,
			})
			vim.opt.showmode = false

			require("mini.completion").setup({ lsp_completion = { source_func = "omnifunc", auto_setup = false } })
			vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
			vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

			local keys = {
				["cr"] = vim.api.nvim_replace_termcodes("<CR>", true, true, true),
				["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
				["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<C-y><CR>", true, true, true),
			}

			_G.cr_action = function()
				if vim.fn.pumvisible() ~= 0 then
					-- If popup is visible, confirm selected item or add new line otherwise
					local item_selected = vim.fn.complete_info()["selected"] ~= -1
					return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
				else
					-- If popup is not visible, use plain `<CR>`. You might want to customize
					-- according to other plugins. For example, to use 'mini.pairs', replace
					-- next line with `return require('mini.pairs').cr()`
					return keys["cr"]
				end
			end

			vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "lua", "vimdoc", "markdown" },
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = {
				enable = true,
				disable = { "ruby" },
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"rose-pine/neovim",
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				styles = { italic = false },
				highlight_groups = {
					MatchParen = { fg = "love", bg = "love", blend = 25 },
				},
			})
			vim.cmd.colorscheme("rose-pine")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = { ["<c-enter>"] = "to_fuzzy_refine" },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Search files" })
			vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Search by grep" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Search telescope builtins" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume search" })
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({
				settings = { save_on_toggle = true },
			})
			vim.keymap.set("n", "ma", function()
				harpoon:list():append()
			end)
			vim.keymap.set("n", "<c-e>", function()
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
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("CustomLspAttach", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local map = function(keys, func, desc)
						vim.keymap.set("", keys, func, { buffer = event.buf, desc = desc })
					end

					vim.api.nvim_set_option_value(
						"omnifunc",
						"v:lua.MiniCompletion.completefunc_lsp",
						{ buf = event.buf }
					)

					local builtin = require("telescope.builtin")
					map("gd", builtin.lsp_definitions, "Goto definition")
					map("<leader>D", builtin.lsp_type_definitions, "Goto type definition")
					map("<leader>ds", builtin.lsp_document_symbols, "List document symbols")
					map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "List workspace symbols")
					map("gr", builtin.lsp_references, "List references")
					map("gI", builtin.lsp_implementations, "Goto implementation")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("gD", vim.lsp.buf.declaration, "Goto declaration")

					if client and client.name == "svelte" then
						vim.api.nvim_create_autocmd("BufWritePost", {
							group = vim.api.nvim_create_augroup("SvelteOnChange", { clear = true }),
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
								library = { vim.env.VIMRUNTIME },
							},
						},
					},
				},
			}

			require("mason").setup()
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			formatters_by_ft = {
				fish = { "fish_indent" },
				go = { "goimports" },
				lua = { "stylua" },
				rust = { "rustfmt" },

				-- prettier (default)
				javascript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				vue = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				scss = { { "prettierd", "prettier" } },
				less = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				jsonc = { { "prettierd", "prettier" } },
				graphql = { { "prettierd", "prettier" } },
				markdown = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },

				-- prettier (via extensions)
				astro = { { "prettierd", "prettier" } },
				svelte = { { "prettierd", "prettier" } },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf, lsp_fallback = true })
				end,
			})
		end,
	},
	{
		"mvllow/matcha.nvim",
		opts = {
			prefix = ",",
			keys = {
				b = "background",
				c = "cmdheight",
				d = "matcha_diagnostics",
				f = "FormatOnSave",
				l = "list",
				n = "number",
				q = "matcha_quickfix",
				s = "laststatus",
				w = "wrap",
			},
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		opts = {
			render = "virtual",
			virtual_symbol = "⏺",
			enable_tailwind = true,
		},
	},
})
