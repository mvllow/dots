--- Global
local opts = { silent = true }

vim.g.mapleader = ' '
vim.keymap.set('n', '<space>', '<nop>', opts)

--- UI
vim.cmd('colorscheme un')

vim.opt.colorcolumn = '80'
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
vim.opt.statusline = ' %f %M %= %l:%c ♥ '
vim.opt.shortmess:append('c')

vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<cr>', opts) -- toggle explorer

-- Equally resize splits
vim.api.nvim_create_autocmd('VimResized', {
	pattern = '*',
	command = 'tabdo wincmd =',
})

--- Editing
vim.opt.mouse = 'a'
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.undofile = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.breakindent = true

vim.keymap.set('i', 'jk', '<esc>', opts) -- escape alternative
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opts) -- move through wrapped lines
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opts) -- move through wrapped lines
vim.keymap.set('v', '<', '<gv', opts) -- dedent (keep selection)
vim.keymap.set('v', '>', '>gv', opts) -- indent (keep selection)

-- Goto
vim.keymap.set('n', 'g.', '`.', opts) -- goto last modification
vim.keymap.set('n', 'go', '<c-o>', opts) -- goto previous position
vim.keymap.set('n', 'gO', '<c-i>', opts) -- goto next position
vim.keymap.set('n', 'gp', '<c-^>', opts) -- goto previous buffer (cycles between two buffers, rather than looping through all buffers)
vim.keymap.set('n', 'gn', ':bnext<cr>', opts) -- goto next buffer
vim.keymap.set('n', 'gm', '%', opts) -- goto matching character: '()', '{}', '[]'

-- Window
vim.keymap.set('n', '<leader>wh', '<c-w><c-h>', opts) -- jump to split to the left
vim.keymap.set('n', '<leader>wj', '<c-w><c-j>', opts) -- jump to split below
vim.keymap.set('n', '<leader>wk', '<c-w><c-k>', opts) -- jump to split above
vim.keymap.set('n', '<leader>wl', '<c-w><c-l>', opts) -- jump to split to the right
vim.keymap.set('n', '<leader>wr', '<c-w><c-r>', opts) -- swap split positions
vim.keymap.set('n', '<leader>ww', '<c-w><c-w>', opts) -- focus next window
vim.keymap.set('n', '<leader>wo', ':only<cr>', opts) -- close other windows

-- Stop 'o' continuing comments
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = '*',
	command = 'setlocal formatoptions-=o',
})

--- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set('n', '<esc>', ':noh<cr>', opts) -- clear search highlights
vim.keymap.set('n', '*', '*N', opts) -- search word under cursor (keep position)
vim.keymap.set('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], opts) -- search selection (keep position)

vim.keymap.set('n', '<leader>f', ':Telescope find_files<cr>', opts) -- search files
vim.keymap.set('n', '<leader>/', ':Telescope live_grep<cr>', opts) -- search text

--- LSP
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- goto previous diagnostic
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- goto next diagnostic
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts) -- show diagnostic message

vim.diagnostic.config({ virtual_text = false })

-- Use lil dots
local signs = { 'Error', 'Warn', 'Hint', 'Info' }
for _, type in pairs(signs) do
	local hl = string.format('DiagnosticSign%s', type)
	vim.fn.sign_define(hl, { text = '●', texthl = hl, numhl = hl })
end

--- Completions
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.pumheight = 3

--- Plugins
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require('packer').startup(function(use)
	use('wbthomason/packer.nvim')
	use('editorconfig/editorconfig-vim')
	use({
		'numToStr/Comment.nvim',
		config = function()
			require('comment').setup()
		end,
	})
	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			require('rose-pine').setup({
				disable_italics = true,
				highlight_groups = {
					ColorColumn = { bg = 'surface' },
					Comment = { fg = 'muted', style = 'italic' },
				},
			})
		end,
	})
	use({
		'mvllow/modes.nvim',
		config = function()
			require('modes').setup()
		end,
	})
	use({
		'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('telescope').setup({
				defaults = {
					layout_config = {
						horizontal = {
							preview_width = 0.6,
						},
					},
				},
				pickers = {
					find_files = {
						theme = 'dropdown',
						previewer = false,
						find_command = {
							'fd',
							'--type',
							'f',
							'--hidden',
							'--exclude',
							'.git',
							'--strip-cwd-prefix',
						},
					},
				},
			})
		end,
	})
	use({
		'kyazdani42/nvim-tree.lua',
		config = function()
			vim.g.nvim_tree_icons = {
				folder = { default = '●', empty = '◌', empty_open = '○', open = '○' },
			}
			vim.g.nvim_tree_show_icons = { folders = 1, files = 0 }
			require('nvim-tree').setup({
				actions = { open_file = { quit_on_open = true } },
				filters = { custom = { '.git$' } },
				git = { ignore = false },
				view = {
					mappings = {
						list = {
							{ key = 'd', action = 'trash' },
							{ key = 'D', action = 'remove' },
						},
					},
					side = 'right',
				},
			})
		end,
	})
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = 'all',
				ignore_install = { 'phpdoc' },
				highlight = { enable = true },
			})
		end,
	})
	use({
		'neovim/nvim-lspconfig',
		requires = 'folke/lua-dev.nvim',
		config = function()
			local function on_attach(client, bufnr)
				-- Disable lsp-provided formatting in favour of null-ls
				client.resolved_capabilities.document_formatting = false

				local b_opts = { buffer = bufnr, silent = true }
				vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, b_opts)
				vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, b_opts)
				vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, b_opts)
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, b_opts)
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, b_opts)
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, b_opts)
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, b_opts)
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Improve compatibility with nvim-cmp completions
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			require('lspconfig').sumneko_lua.setup(require('lua-dev').setup({
				lspconfig = {
					on_attach = on_attach,
					capabilities = capabilities,
				},
			}))

			-- Language servers to setup. Servers must be available in your path.
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			local servers = { 'cssls', 'html', 'jsonls', 'svelte', 'tailwindcss', 'tsserver' }
			for _, server in ipairs(servers) do
				require('lspconfig')[server].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end
		end,
	})
	use({
		'jose-elias-alvarez/null-ls.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			local null_ls = require('null-ls')
			null_ls.setup({
				sources = {
					null_ls.builtins.code_actions.xo,
					null_ls.builtins.diagnostics.xo,
					null_ls.builtins.formatting.fish_indent,
					null_ls.builtins.formatting.prettierd.with({
						extra_filetypes = { 'svelte', 'jsonc' },
					}),
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.stylua,
				},
				on_attach = function(client)
					if client.resolved_capabilities.document_formatting then
						vim.api.nvim_create_autocmd('BufWritePre', {
							pattern = '<buffer>',
							callback = function()
								vim.lsp.buf.formatting_sync()
							end,
						})
					end
				end,
			})
		end,
	})
	use({
		'hrsh7th/nvim-cmp',
		requires = { 'L3MON4D3/LuaSnip', 'hrsh7th/cmp-nvim-lsp' },
		config = function()
			local cmp = require('cmp')
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
				sources = {
					{ name = 'nvim_lsp' },
				},
			})
		end,
	})
end)
