--- lil-lsp.lua
--- https://github.com/mvllow/lilvim

--- Setup language servers, diagnostics and formatting.

local use = require('lil-helpers').use

use({
	'neovim/nvim-lspconfig',
	requires = 'folke/lua-dev.nvim',
	config = function()
		local function on_attach(_, bufnr)
			local map = require('lil-helpers').map
			map('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = bufnr })
			map('n', '<leader>a', vim.lsp.buf.code_action, { buffer = bufnr })
			map('n', '<leader>r', vim.lsp.buf.rename, { buffer = bufnr })
			map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
			map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
			map('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })
			map('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- Improve compatibility with nvim-cmp completions
		local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
		if has_cmp_nvim_lsp then
			capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
		end

		local lspconfig = require('lspconfig')
		lspconfig.sumneko_lua.setup(require('lua-dev').setup({
			lspconfig = {
				on_attach = on_attach,
				capabilities = capabilities,
			},
		}))

		-- Language servers to setup. Servers must be available in your path.
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		local servers = {
			'cssls',
			'gopls',
			'html',
			'jsonls',
			'rust_analyzer',
			'svelte',
			'tailwindcss',
			'tsserver',
			'volar',
		}

		for _, server in ipairs(servers) do
			local settings = {}

			if server == 'cssls' then
				settings = {
					css = { validate = false },
				}
			end

			lspconfig[server].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = settings,
			})
		end
	end,
})
use({
	'jose-elias-alvarez/null-ls.nvim',
	requires = 'nvim-lua/plenary.nvim',
	config = function()
		local null_ls = require('null-ls')
		local sources = {
			null_ls.builtins.code_actions.xo,
			null_ls.builtins.diagnostics.xo,
			null_ls.builtins.formatting.fish_indent,
			null_ls.builtins.formatting.gofmt,
			null_ls.builtins.formatting.goimports,
			null_ls.builtins.formatting.prettierd.with({
				extra_filetypes = { 'svelte' },
			}),
			null_ls.builtins.formatting.rustfmt,
			null_ls.builtins.formatting.shfmt,
			null_ls.builtins.formatting.stylua,
		}

		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				if client.supports_method('textDocument/formatting') then
					vim.api.nvim_create_autocmd('BufWritePre', {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(lsp_client)
									return lsp_client.name == 'null-ls'
								end,
							})
						end,
					})
				end
			end,
		})
	end,
})