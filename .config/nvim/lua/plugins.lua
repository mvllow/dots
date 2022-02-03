local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require('packer').startup(function(use)
	use('wbthomason/packer.nvim')
	use('editorconfig/editorconfig-vim')
	use({
		'mvllow/nvim-markdown-preview',
		run = 'brew install pandoc && npm i -g live-server',
	})
	use({
		'numToStr/Comment.nvim',
		config = function()
			require('comment').setup()
		end,
	})
	use({
		'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('telescope').setup({
				defaults = {
					layout_config = { horizontal = { preview_width = 0.6 } },
				},
				pickers = {
					find_files = {
						find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
						theme = 'dropdown',
						previewer = false,
					},
				},
			})
		end,
	})
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		requires = { 'nvim-treesitter/playground', 'windwp/nvim-ts-autotag' },
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = 'maintained',
				ignore_install = { 'haskell' },
				indent = { enable = true },
				autotag = { enable = true },
				highlight = { enable = true },
				playground = { enable = true },
			})
		end,
	})
	use({
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup()
		end,
	})
	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.g.rose_pine_disable_italics = true
			vim.cmd('colorscheme rose-pine')
		end,
	})
	use({
		'kyazdani42/nvim-tree.lua',
		config = function()
			vim.g.nvim_tree_icons = {
				folder = { default = '>', empty = '>', empty_open = '▼', open = '▼' },
			}
			vim.g.nvim_tree_quit_on_open = 1
			vim.g.nvim_tree_show_icons = { folders = 1, files = 0 }
			require('nvim-tree').setup({
				auto_close = true,
				filters = { custom = { '.git' } },
				git = { ignore = false },
				view = { side = 'right' },
			})
		end,
	})
	use({
		'neovim/nvim-lspconfig',
		requires = 'folke/lua-dev.nvim',
		config = function()
			local function on_attach(client, bufnr)
				client.resolved_capabilities.document_formatting = false
				local function map_buffer(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
				end

				map_buffer('i', '<c-k>', vim.lsp.buf.signature_help, 'signature help')
				map_buffer('n', '<leader>a', vim.lsp.buf.code_action, 'code action')
				map_buffer('n', '<leader>r', vim.lsp.buf.rename, 'rename symbol')
				map_buffer('n', 'K', vim.lsp.buf.hover, 'symbol hover')
				map_buffer('n', 'gd', vim.lsp.buf.definition, 'goto definition')
				map_buffer('n', 'gi', vim.lsp.buf.implementation, 'goto implementation')
				map_buffer('n', 'gr', vim.lsp.buf.references, 'show references')
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			local lspconfig = require('lspconfig')
			lspconfig.sumneko_lua.setup(require('lua-dev').setup({
				lspconfig = { on_attach = on_attach, capabilities = capabilities },
			}))

			local servers = {
				'html',
				'jsonls',
				'cssls',
				'tailwindcss',
				'tsserver',
				'volar',
				'svelte',
				'gopls',
			}
			for _, server in ipairs(servers) do
				lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
			end
		end,
	})
	use({
		'jose-elias-alvarez/null-ls.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function()
			local null_ls = require('null-ls')
			local formatting = null_ls.builtins.formatting

			null_ls.setup({
				sources = {
					formatting.fish_indent,
					formatting.prettierd.with({ extra_filetypes = { 'svelte', 'jsonc' } }),
					formatting.shfmt.with({ extra_filetypes = { 'bash', 'sh', 'zsh' } }),
					formatting.stylua,
				},
				on_attach = function(client)
					if client.resolved_capabilities.document_formatting then
						vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]])
					end
				end,
			})
		end,
	})
	use({
		'hrsh7th/nvim-cmp',
		requires = { 'L3MON4D3/LuaSnip', 'hrsh7th/cmp-nvim-lsp', 'windwp/nvim-autopairs' },
		config = function()
			local cmp = require('cmp')
			cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = {
					['<c-space>'] = cmp.mapping.complete(),
					['<cr>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
					['<tab>'] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end,
					['<s-tab>'] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
				},
				sources = { { name = 'nvim_lsp' } },
			})
		end,
	})
end)
