-- Bootstrap lazy.nvim plugin manager
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

local plugins = {
	{ "lewis6991/gitsigns.nvim", config = true },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = { enable = true },
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		branch = "canary",
		config = function()
			require("rose-pine").setup({
				disable_italics = true,
				disable_float_background = true,
				highlight_groups = {
					Comment = { fg = "muted", italic = true },
				},
			})
			vim.cmd.colorscheme("rose-pine")
		end,
	},
	{
		"numToStr/Comment.nvim",
		dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
		keys = {
			{ "gc", mode = { "n", "v", "x" } },
			{ "gb", mode = { "n", "v", "x" } },
		},
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
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
			{
				"<leader>d",
				"<cmd>Telescope diagnostics<cr>",
				desc = "Diagnostics",
			},
		},
		opts = { defaults = { layout_config = { horizontal = { preview_width = 80 } } } },
	},
	{
		"nvim-tree/nvim-tree.lua",
		keys = {
			{ "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle file tree" },
		},
		opts = {
			actions = { open_file = { quit_on_open = true } },
			git = { ignore = false },
			renderer = { icons = { show = { file = false, folder = false, folder_arrow = false, git = false } } },
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
	{
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
			require("mini.completion").setup({
				lsp_completion = { source_func = "omnifunc", auto_setup = false },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{ "folke/neodev.nvim", config = true },
			{ "williamboman/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUninstall" }, config = true },
			{ "williamboman/mason-lspconfig.nvim", config = true },
		},
		config = function()
			local function on_attach(_, bufnr)
				-- Use omnifunc for completions
				-- https://github.com/echasnovski/nvim/blob/487ce206d88412db5577435ba956fcf5a19d6302/lua/ec/configs/nvim-lspconfig.lua#L11-L26
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")

				local function map(mode, lhs, rhs, opts)
					opts = opts or {}
					opts.buffer = opts.buffer or bufnr
					opts.silent = opts.silent == nil and true or opts.silent
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				map("i", "<c-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
				map("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
				map("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr })
				map("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
				map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
				map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
				map("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
				map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
				map("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
				map("n", "<leader>k", vim.diagnostic.open_float, { buffer = bufnr })
				map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
				map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local lspconfig = require("lspconfig")
			local servers = require("_languages").get_servers(lspconfig)

			require("mason").setup()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local opts = {}
					if servers[server_name] ~= nil then
						opts = servers[server_name]
					end

					lspconfig[server_name].setup(vim.tbl_deep_extend("force", {
						on_attach = on_attach,
						capabilities = capabilities,
					}, opts))
				end,
			})
		end,
	},
	{
		-- Setup formatters and linters
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = "nvim-lua/plenary.nvim",
		keys = { { "<space><space>", vim.lsp.buf.format, desc = "Format" } },
		config = function()
			local null_ls = require("null-ls")
			local sources = require("_languages").get_sources(null_ls)
			local lsp_formatter_names = require("_languages").lsp_formatter_names or {}

			local lsp_formatting = function(bufnr)
				vim.lsp.buf.format({
					bufnr = bufnr,
					filter = function(client)
						return client.name == "null-ls" or vim.tbl_contains(lsp_formatter_names, client.name)
					end,
				})
			end

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			local on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							lsp_formatting(bufnr)
						end,
					})
				end
			end

			null_ls.setup({
				sources = sources,
				on_attach = on_attach,
			})
		end,
	},
}

require("lazy").setup(plugins, { change_detection = { notify = false } })
