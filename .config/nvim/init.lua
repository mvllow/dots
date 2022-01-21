local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.g.mapleader = ' '
vim.keymap.set('n', '<space>', '<nop>', { silent = true }) -- allow `space` as leader
vim.keymap.set('i', 'jk', '<esc>', { silent = true }) -- alternative escape
vim.keymap.set('n', 'j', 'gj', { silent = true }) -- move through wrapped lines (down)
vim.keymap.set('n', 'k', 'gk', { silent = true }) -- move through wrapped lines (up)
vim.keymap.set('n', '<esc>', ':noh<cr>', { silent = true }) -- clear highlights on escape
vim.keymap.set('n', '<c-h>', '<c-w><c-h>', { silent = true }) -- move to split (left)
vim.keymap.set('n', '<c-j>', '<c-w><c-j>', { silent = true }) -- move to split (down)
vim.keymap.set('n', '<c-k>', '<c-w><c-k>', { silent = true }) -- move to split (up)
vim.keymap.set('n', '<c-l>', '<c-w><c-l>', { silent = true }) -- move to split (right)
vim.keymap.set('v', '<', '<gv', { silent = true }) -- reselect indented text (left)
vim.keymap.set('v', '>', '>gv', { silent = true }) -- reselect indented text (right)
vim.keymap.set('n', '*', '*N', { silent = true }) -- keep `*` selection on current word
vim.keymap.set('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { silent = true }) -- mimic normal mode `*` selection (and keep on current word)
vim.keymap.set('n', '-', ':m .+1<cr>==', { silent = true }) -- bubble line (up)
vim.keymap.set('n', '_', ':m .-2<cr>==', { silent = true }) -- bubble line (down)
vim.keymap.set('v', '-', ":m '>+1<cr>gv=gv", { silent = true }) -- bubble selection (up)
vim.keymap.set('v', '_', ":m '<-2<cr>gv=gv", { silent = true }) -- bubble selection (down)
vim.keymap.set('n', 'H', ':bprevious<cr>', { silent = true })
vim.keymap.set('n', 'L', ':bnext<cr>', { silent = true })
vim.keymap.set('n', '<leader>d', ':bdelete<cr>', { silent = true })
vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<cr>', { silent = true })
vim.keymap.set('n', '<leader>ps', ':PackerSync<cr>', { silent = true })
vim.keymap.set('n', '<leader>h', ':TSHighlightCapturesUnderCursor<cr>', { silent = true })

vim.opt.mouse = 'a'
vim.opt.breakindent = true
vim.opt.shortmess:append('c')
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = 'yes'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.pumheight = 10
vim.opt.wrap = false
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.laststatus = 2
vim.opt.statusline = '%f %M %= %l:%c ♥'

vim.diagnostic.config({ virtual_text = false })

vim.cmd('autocmd BufEnter * setlocal formatoptions-=o')
vim.cmd('autocmd VimResized * tabdo wincmd =')
vim.cmd('autocmd BufRead,BufNewFile *.json set ft=jsonc')

require('packer').startup(function(use)
	use('wbthomason/packer.nvim')
	use('editorconfig/editorconfig-vim')
	use('tpope/vim-commentary')
	use({
		'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('telescope').setup({
				defaults = { layout_config = { horizontal = { preview_width = 0.6 } } },
				pickers = { find_files = { theme = 'dropdown', previewer = false } },
			})

			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>f', builtin.find_files, { silent = true })
			vim.keymap.set('n', '<leader>st', builtin.live_grep, { silent = true })
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
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		requires = { 'nvim-treesitter/playground', 'JoosepAlviste/nvim-ts-context-commentstring' },
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = 'maintained',
				ignore_install = { 'haskell' },
				indent = { enable = true },
				highlight = { enable = true },
				context_commentstring = { enable = true, enable_autocmd = false },
				playground = { enable = true },
			})
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
		requires = { 'folke/lua-dev.nvim' },
		config = function()
			local function on_attach(client)
				client.resolved_capabilities.document_formatting = false

				vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, { buffer = true })
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = true })
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true })
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = true })
				vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { buffer = true })
				vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, { buffer = true })
				vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, { buffer = true })
				vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { buffer = true })
				vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = true })
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			local lspconfig = require('lspconfig')
			lspconfig.sumneko_lua.setup(require('lua-dev').setup({
				lspconfig = { on_attach = on_attach, capabilities = capabilities },
			}))

			local servers = { 'html', 'jsonls', 'cssls', 'tailwindcss', 'tsserver', 'volar', 'svelte' }
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
		requires = { 'L3MON4D3/LuaSnip', 'hrsh7th/cmp-nvim-lsp' },
		config = function()
			local cmp = require('cmp')
			cmp.setup({
				documentation = false,
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
