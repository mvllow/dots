vim.g.mapleader = " "

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
vim.o.grepprg = "rg --vimgrep -uu --smart-case"

require("lil-quickfix")

-- Navigate between wrapped lines
vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })

-- Navigate popup menu
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

vim.keymap.set("n", "gl", vim.diagnostic.open_float)

vim.api.nvim_create_autocmd("VimResized", { command = "tabdo wincmd =" })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end
})

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
		source = "rose-pine/neovim",
		as = "rose-pine",
		config = function()
			require("rose-pine").setup({
				palette = {
					main = {
						pine = "#4097BA"
					}
				},
				styles = { italic = false, },
			})
			vim.cmd.colorscheme("rose-pine")
		end
	},
	{
		source = "echasnovski/mini.nvim",
		config = function()
			require("mini.comment").setup()

			require("mini.completion").setup()

			require("mini.diff").setup({ view = { signs = { add = "+", change = "~", delete = "-" } } })

			require("mini.files").setup({
				options = {
					permanent_delete = false,
				}
			})
			vim.keymap.set("n", "<leader>e", function()
				require("mini.files").open(vim.api.nvim_buf_get_name(0))
			end)

			-- TIP: Remember that <c-o> allows filtering grep results by filename.
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
		end
	},
	{
		source = "neovim/nvim-lspconfig",
		dependencies = {
			{ source = "williamboman/mason.nvim" },
			{ source = "williamboman/mason-lspconfig.nvim" }
		},
		config = function()
			local cwd = vim.fn.getcwd()
			local servers = {
				angularls = {
					cmd = { "ngserver", "--stdio", "--tsProbeLocations", cwd, "--ngProbeLocations", cwd },
					root_dir = require("lspconfig.util").root_pattern("angular.json", "nx.json"),
					on_new_config = function(new_config)
						new_config.cmd = { "ngserver", "--stdio", "--tsProbeLocations", cwd, "--ngProbeLocations", cwd }
					end,
				},
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									"${3rd}/luv/library"
								},
							},
						},
					},
				},
				denols = {
					root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
				},
				ts_ls = {
					root_dir = require("lspconfig").util.root_pattern("package.json"),
					single_file_support = false
				},
			}

			require("mason").setup()
			require("mason-lspconfig").setup({
				handlers = {
					function(server)
						local opts = servers[server] or {}
						require("lspconfig")[server].setup(opts)
					end
				}
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("CustomLspAttach", { clear = false }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end

					-- vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = false })

					vim.b.minicompletion_config = { lsp_completion = { source_func = "omnifunc", auto_setup = false } }
					vim.api.nvim_set_option_value(
						"omnifunc",
						"v:lua.MiniCompletion.completefunc_lsp",
						{ buf = args.buf }
					)
				end
			})
		end
	},
	{
		source = "stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				notify_on_error = false,
				default_format_opts = {
					lsp_format = "fallback"
				},
				formatters_by_ft = {
					fish = { "fish_indent" },
					go = { "goimports" },
					sh = { "shfmt" },

					-- prettier (default)
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

					-- prettier (via extensions)
					astro = { "prettier" },
					svelte = { "prettier" },
				},
			})

			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

			vim.keymap.set("n", "gq", function()
				vim.lsp.buf.format()
				-- Workaround for diagnostics disappearing when formatting with no changes
				-- https://github.com/neovim/neovim/issues/25014
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
		source = "mvllow/supplement.nvim",
		config = function()
			require("supplement").setup()
		end
	},
})

vim.opt.rtp:append("~/dev/matcha.nvim")
require("matcha").setup({ prefix = "," })
