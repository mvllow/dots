-- Setup language servers.
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
return {
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
				opts.silent = opts.silent or true
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

				-- Remove shared root_dirs between deno and tsserver.
				-- https://deno.land/manual@v1.28.3/getting_started/setup_your_environment#neovim-06-using-the-built-in-language-server
				if server_name == "denols" then
					opts = {
						root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
					}
				end
				if server_name == "tsserver" then
					opts = {
						single_file_support = false,
						root_dir = require("lspconfig").util.root_pattern("package.json"),
					}
				end

				require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", {
					on_attach = on_attach,
					capabilities = capabilities,
				}, opts))
			end,
		})
	end,
}
