local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
else
	require('impatient')
end

vim.cmd([[
	augroup Packer
		autocmd!
		autocmd BufWritePost init.lua PackerCompile
	augroup end
]])

local function map(mode, lhs, rhs, opts)
	opts = opts or { noremap = true, silent = true }
	return vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

vim.g.mapleader = ' '
map('n', '<space>', '<nop>')

map('i', 'jk', '<esc>')
map('n', 'j', 'gj')
map('n', 'k', 'gk')
map('n', '<esc>', ':noh<cr>')

map('n', '<c-h>', '<c-w><c-h>')
map('n', '<c-j>', '<c-w><c-j>')
map('n', '<c-k>', '<c-w><c-k>')
map('n', '<c-l>', '<c-w><c-l>')

map('v', '<', '<gv')
map('v', '>', '>gv')

map('n', '*', '*N')
map('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])

map('n', '<leader>pc', ':PackerCompile<cr>')
map('n', '<leader>ps', ':PackerSync<cr>')

map('n', 'L', ':BufferNext<cr>')
map('n', 'H', ':BufferPrevious<cr>')
map('n', '<leader>d', ':BufferClose<cr>')
map('n', '<leader>bo', ':BufferCloseAllButCurrent<cr>')

map('n', '<leader>e', ':NvimTreeToggle<cr>')

map('n', '<leader>h', ':TSHighlightCapturesUnderCursor<cr>')

map('n', '<leader>f', [[:lua require('telescope.builtin').find_files()<cr>]])
map('n', '<leader>st', [[:lua require('telescope.builtin').live_grep()<cr>]])

vim.opt.mouse = 'a'
vim.opt.breakindent = true
vim.opt.shortmess:append('c')
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = 'yes'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

vim.cmd('autocmd BufEnter * setlocal formatoptions-=o')
vim.cmd('autocmd VimResized * tabdo wincmd =')

require('packer').startup(function(use)
	use('wbthomason/packer.nvim')
	use('lewis6991/impatient.nvim')
	use('editorconfig/editorconfig-vim')
	use('b0o/schemastore.nvim')
	use('tpope/vim-commentary')
	use({
		'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('telescope').setup({
				defaults = {
					winblend = 10,
					layout_config = {
						horizontal = { preview_width = 0.6 },
					},
				},
				pickers = {
					find_files = { theme = 'dropdown', previewer = false },
				},
			})
		end,
	})
	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.opt.termguicolors = true
			vim.g.rose_pine_disable_italics = true
			vim.cmd('colorscheme rose-pine')
		end,
	})
	use({
		'romgrk/barbar.nvim',
		config = function()
			vim.g.bufferline = {
				animation = false,
				icon_close_tab = '×',
				icon_close_tab_modified = '♥',
				icons = false,
			}
		end,
	})
	use({
		'kyazdani42/nvim-tree.lua',
		config = function()
			vim.g.nvim_tree_git_hl = 1
			vim.g.nvim_tree_icons = {
				folder = {
					default = '>',
					empty = '>',
					empty_open = '▼',
					open = '▼',
				},
			}
			vim.g.nvim_tree_quit_on_open = 1
			vim.g.nvim_tree_show_icons = { folders = 1, files = 0 }
			require('nvim-tree').setup({
				auto_close = true,
				filters = {
					custom = { '.git' },
				},
				view = {
					side = 'right',
				},
			})
		end,
	})
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		requires = {
			'nvim-treesitter/playground',
			'windwp/nvim-ts-autotag',
			'JoosepAlviste/nvim-ts-context-commentstring',
		},
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = 'maintained',
				ignore_install = { 'haskell' },
				indent = { enable = true },
				autotag = { enable = true },
				highlight = { enable = true },
				context_commentstring = { enable = true, enable_autocmd = false },
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
		'neovim/nvim-lspconfig',
		requires = { 'folke/lua-dev.nvim', 'williamboman/nvim-lsp-installer' },
		config = function()
			vim.opt.completeopt = 'menu,menuone,noselect'
			vim.opt.pumheight = 10

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			local function on_attach(client, bufnr)
				client.resolved_capabilities.document_formatting = false
				client.resolved_capabilities.document_range_formatting = false

				vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

				local function buf_map(mode, lhs, rhs, opts)
					opts = opts or { noremap = true, silent = true }
					vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
				end

				buf_map('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
				buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
				buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
				buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
				buf_map('n', 'gl', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<cr>')
				buf_map('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
				buf_map('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<cr>')
				buf_map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
				buf_map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
			end

			local lsp_installer = require('nvim-lsp-installer')

			lsp_installer.on_server_ready(function(server)
				local opts = {
					capabilities = capabilities,
					on_attach = on_attach,
				}

				if server.name == 'sumneko_lua' then
					opts = vim.tbl_extend('force', opts, require('lua-dev').setup())
				end

				if server.name == 'jsonls' then
					opts = vim.tbl_extend('force', opts, {
						settings = {
							json = {
								schemas = require('schemastore').json.schemas(),
							},
						},
					})
				end

				server:setup(opts)

				vim.cmd('do User LspAttachBuffers')
			end)

			vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
				vim.lsp.diagnostic.on_publish_diagnostics,
				{
					signs = true,
					underline = true,
					update_in_insert = false,
					virtual_text = false,
				}
			)
		end,
	})
	use({
		'jose-elias-alvarez/null-ls.nvim',
		requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
		config = function()
			local null_ls = require('null-ls')

			null_ls.config({
				sources = {
					null_ls.builtins.formatting.fish_indent,
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.prettier.with({
						filetypes = {
							'javascript',
							'javascriptreact',
							'typescript',
							'typescriptreact',
							'vue',
							'css',
							'scss',
							'less',
							'html',
							'json',
							'jsonc',
							'yaml',
							'markdown',
							'graphql',
							'svelte',
						},
						extra_args = { '--plugin-search-dir=.' },
					}),
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.shfmt.with({ filetypes = { 'bash', 'sh', 'zsh' } }),
					null_ls.builtins.formatting.stylua,
				},
			})

			require('lspconfig')['null-ls'].setup({
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
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			local cmp = require('cmp')

			cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},

				mapping = {
					['<tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { 'i', 's' }),

					['<s-tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<c-space>'] = cmp.mapping.complete(),
					['<cr>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
				},
				sources = {
					{ name = 'nvim_lsp' },
				},
			})
		end,
	})
end)
