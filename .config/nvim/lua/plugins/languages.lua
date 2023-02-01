return {
	-- Setup language servers.
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{ "folke/neodev.nvim", config = true },
			{ "williamboman/mason.nvim", cmd = "Mason", config = true },
			{ "williamboman/mason-lspconfig.nvim", config = true },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim", opts = {} },
		},
		config = function()
			local function on_attach(_, bufnr)
				local function map(mode, lhs, rhs, opts)
					opts = opts or {}
					opts.buffer = opts.buffer or bufnr
					opts.silent = opts.silent == nil and true or opts.silent
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
				map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code actions" })
				map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
				map("n", "K", vim.lsp.buf.hover, { desc = "Documenation" })
				map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
				map("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
				map("n", "gt", vim.lsp.buf.type_definition, { desc = "Goto type definition" })
				map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto implementation" })
				map("n", "gr", vim.lsp.buf.references, { desc = "Goto references" })
				map("n", "gl", vim.diagnostic.open_float, { desc = "Diagnostics" })
				map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
				map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.offsetEncoding = { "utf-16" }

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local opts = {}
					local root_pattern = require("lspconfig").util.root_pattern

					-- Remove shared root_dirs between deno and tsserver.
					-- https://deno.land/manual@v1.28.3/getting_started/setup_your_environment#neovim-06-using-the-built-in-language-server
					if server_name == "denols" then
						opts = {
							root_dir = root_pattern("deno.json", "deno.jsonc"),
						}
					end
					if server_name == "tailwindcss" then
						opts = {
							root_dir = root_pattern("tailwind.config.js", "tailwind.config.cjs"),
						}
					end
					if server_name == "tsserver" then
						opts = {
							single_file_support = false,
							root_dir = root_pattern("tsconfig.json", "tsconfig.jsonc"),
						}
					end

					require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", {
						on_attach = on_attach,
						capabilities = capabilities,
					}, opts))
				end,
			})
		end,
	},

	-- Setup formatters and linters.
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-lua/plenary.nvim", "jayp0521/mason-null-ls.nvim" },
		keys = {
			{ "<space><space>", vim.lsp.buf.format, desc = "Format" },
		},
		config = function()
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			local function format_on_save(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({
						group = augroup,
						buffer = bufnr,
					})
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(lsp_client)
									return lsp_client.name == "null-ls" or lsp_client.name == "denols"
								end,
							})
						end,
					})
				end
			end

			require("mason-null-ls").setup({ automatic_setup = true })
			require("null-ls").setup({
				sources = {
					require("null-ls").builtins.completion.spell,
					require("null-ls").builtins.formatting.fish_indent,
					require("null-ls").builtins.formatting.prettierd.with({
						extra_filetypes = { "jsonc", "astro", "svelte" },
					}),
				},
				on_attach = format_on_save,
			})
			require("mason-null-ls").setup_handlers({})
		end,
	},
	-- Setup completions.
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
			require("mini.completion").setup()
		end,
	},
}
