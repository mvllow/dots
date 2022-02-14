vim.opt.title = true
vim.opt.mouse = 'a'
vim.opt.shortmess:append('c')
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = 'yes'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.pumheight = 4
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.laststatus = 2
vim.opt.statusline = ' %f %M %= %l:%c ♥ '
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·' }
vim.opt.wrap = false
vim.opt.breakindent = true

vim.cmd('autocmd BufEnter * setlocal formatoptions-=o')
vim.cmd('autocmd VimResized * tabdo wincmd =')
vim.cmd('autocmd BufRead,BufNewFile *.json set ft=jsonc')

vim.diagnostic.config({ virtual_text = false })

local signs = { 'Error', 'Warn', 'Hint', 'Info' }
for _, type in pairs(signs) do
	local hl = string.format('DiagnosticSign%s', type)
	vim.fn.sign_define(hl, { text = '●', texthl = hl, numhl = hl })
end

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc or '' })
end

vim.g.mapleader = ' '
map('n', '<space>', '<nop>')
map('n', '<esc>', ':noh<cr>')
map('i', 'jk', '<esc>')
map({ 'n', 'v' }, 'j', 'gj')
map({ 'n', 'v' }, 'k', 'gk')
map('v', '<', '<gv')
map('v', '>', '>gv')
map('n', '*', '*N')
map('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])
map('n', '#', '*Ncgn')
map('v', '#', [[y/\V<c-r>=escape(@",'/\')<cr><cr>Ncgn]])
map({ 'n', 'v' }, '<leader>y', '"*y', 'yank selection to clipboard')
map('n', '<leader>P', '<c-r>', 'paste selection inline')

-- window
map('n', '<leader>wF', '<c-w>vgf', 'goto file (vsplit)')
map('n', '<leader>wf', '<c-w><c-f>', 'goto file (hsplit)')
map('n', '<leader>wh', '<c-w><c-h>', 'jump to split to the left')
map('n', '<leader>wj', '<c-w><c-j>', 'jump to split below')
map('n', '<leader>wk', '<c-w><c-k>', 'jump to split above')
map('n', '<leader>wl', '<c-w><c-l>', 'jump to split to the right')
map('n', '<leader>wr', '<c-w><c-r>', 'swap split positions')
map('n', '<leader>wo', ':only<cr>', 'close other windows')
map('n', '<leader>wq', ':quit<cr>', 'close window')
map('n', '<leader>ws', ':split<cr>', 'open split to the right')
map('n', '<leader>wv', ':vsplit<cr>', 'open split below')
map('n', '<leader>ww', '<c-w><c-w>', 'goto next window')

-- goto
map('n', 'gf', ':edit <cfile><cr>', 'goto file')
map('n', 'gh', '^', 'goto line start')
map('n', 'g.', '`.', 'goto last modification')
map('n', 'go', '<c-o>', 'goto previous position')
map('n', 'gO', '<c-i>', 'goto next position')
map('n', 'gp', ':bprevious<cr>', 'goto previous buffer')
map('n', 'gn', ':bnext<cr>', 'goto next buffer')

-- diagnostic
map('n', '[d', vim.diagnostic.goto_prev, 'goto next diagnostic')
map('n', ']d', vim.diagnostic.goto_next, 'goto previous diagnostic')
map('n', 'gl', vim.diagnostic.open_float, 'show diagnostic message')

-- plugin
map('n', '<leader>/', ':Telescope live_grep<cr>', 'search text')
map('n', '<leader>b', ':Telescope buffers<cr>', 'search buffers')
map('n', '<leader>f', ':Telescope find_files<cr>', 'search files')
map('n', '<leader>e', ':NvimTreeFindFileToggle<cr>', 'explorer')
map('n', '<leader>h', ':TSHighlightCapturesUnderCursor<cr>', 'show highlight group under cursor')
map('n', '<leader>pc', ':PackerCompile<cr>', 'compile plugins')
map('n', '<leader>ps', ':PackerSync<cr>', 'sync plugins')

local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
	vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. packer_path)
end

require('packer').startup(function(use)
	use('wbthomason/packer.nvim')
	use('editorconfig/editorconfig-vim')
	use({
		'davidgranstrom/nvim-markdown-preview',
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
			require('rose-pine').setup({
				disable_italics = true,
				groups = {
					punctuation = 'muted',
				},
			})
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
				auto_reload_on_write = true,
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

			local servers = { 'html', 'jsonls', 'cssls', 'tailwindcss', 'tsserver', 'svelte', 'gopls' }
			for _, server in ipairs(servers) do
				lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
			end
		end,
	})
	use({
		'jose-elias-alvarez/null-ls.nvim',
		requires = 'nvim-lua/plenary.nvim',
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
