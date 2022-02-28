-- Enable mouse support
vim.opt.mouse = 'a'

-- Create horizontal splits below current (:split)
vim.opt.splitbelow = true
-- Create vertical splits to the right of current (:vsplit)
vim.opt.splitright = true

-- Indent width when using <tab>
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
-- Indent width when using >, >>, <, and << commands
-- 0 matches |tabstop|
vim.opt.shiftwidth = 4

-- Enable persistent undo between sessions
vim.opt.undofile = true

-- Ignore case when searching (/)
vim.opt.ignorecase = true
-- Unless search contains an uppercase character
vim.opt.smartcase = true

-- Time in milliseconds to update swap files and |CursorHold|
vim.opt.updatetime = 250

-- Shorten file messages to avoid hit-enter prompts
vim.opt.shortmess:append('c')

-- Always show signcolumn
-- Used for diagnostics, symbols, etc.
vim.opt.signcolumn = 'yes'

-- Popup menu height
-- Used for completions, etc.
vim.opt.pumheight = 3

-- Scroll offset
-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 3

-- Wrap lines
vim.opt.wrap = false
vim.opt.breakindent = true

-- Statusline
-- %f filename
-- %M modified status, eg. "+" when unsaved
-- %= start of right side
-- %l current line
-- %c current column
-- ♥  love all
vim.opt.statusline = ' %f %M %= %l:%c ♥ '

local function create_autocmd(event, pattern, command)
	vim.api.nvim_create_autocmd({ event = event, pattern = pattern, command = command })
end

-- Remove continuation of comments when creating a new line via `o`
create_autocmd('BufEnter', '*', 'setlocal formatoptions-=o')
-- Ensure splits are equal width when resizing vim
create_autocmd('VimResized', '*', 'tabdo wincmd =')
-- Set json filetype to jsonc
create_autocmd({ 'BufRead', 'BufNewFile' }, '*.json', 'set ft=jsonc')

-- Diagnostics
vim.diagnostic.config({ virtual_text = false })

-- Create diagnostic signs
local signs = { 'Error', 'Warn', 'Hint', 'Info' }
for _, type in pairs(signs) do
	local hl = string.format('DiagnosticSign%s', type)
	vim.fn.sign_define(hl, { text = '●', texthl = hl, numhl = hl })
end

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc or '' })
end

-- Set map prefix, eg. <leader>
vim.g.mapleader = ' '
map('n', '<space>', '<nop>')

map('i', 'jk', '<esc>', 'escape alternative')
map('n', '<esc>', ':noh<cr>', 'clear search highlights')
map({ 'n', 'v' }, 'j', 'gj', 'move through wrapped lines')
map({ 'n', 'v' }, 'k', 'gk', 'move through wrapped lines')
map('v', '<', '<gv', 'dedent (keep selection)')
map('v', '>', '>gv', 'indent (keep selection)')
map('n', '*', '*N', 'search word under cursor (keep position)')
map('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], 'search selection (keep position)')

map('n', '<leader>o', ':set wrap!<cr>', 'toggle word wrap')
map('n', '<leader>d', ':bdelete<cr>', 'delete buffer')
map('n', '<leader>e', ':NvimTreeFindFileToggle<cr>', 'toggle explorer')
map('n', '<leader>/', ':Telescope live_grep<cr>', 'search text')
map('n', '<leader>f', ':Telescope find_files theme=dropdown<cr>', 'search files')
map('n', '<leader>pc', ':PackerCompile<cr>', 'compile plugins')
map('n', '<leader>ps', ':PackerSync<cr>', 'sync plugins')

map('n', '<leader>wh', '<c-w><c-h>', 'jump to split to the left')
map('n', '<leader>wj', '<c-w><c-j>', 'jump to split below')
map('n', '<leader>wk', '<c-w><c-k>', 'jump to split above')
map('n', '<leader>wl', '<c-w><c-l>', 'jump to split to the right')
map('n', '<leader>wr', '<c-w><c-r>', 'swap split positions')
map('n', '<leader>ww', '<c-w><c-w>', 'goto next window')
map('n', '<leader>wo', ':only<cr>', 'close other windows')

map('n', 'g.', '`.', 'goto last modification')
map('n', 'go', '<c-o>', 'goto previous position')
map('n', 'gO', '<c-i>', 'goto next position')
map('n', 'gp', '<c-^>', 'goto previous buffer')
map('n', 'gn', ':bnext<cr>', 'goto next buffer')
map('n', 'gm', '%', "goto matching character: '()', '{}', '[]'")

map('n', '[d', vim.diagnostic.goto_prev, 'goto next diagnostic')
map('n', ']d', vim.diagnostic.goto_next, 'goto previous diagnostic')
map('n', 'gl', vim.diagnostic.open_float, 'show diagnostic message')

-- Bootstrap packer.nvim
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
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup()
		end,
	})
	use({
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end,
	})
	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			require('rose-pine').setup({ disable_italics = true })
			vim.cmd('colorscheme rose-pine')
		end,
	})
	use({
		'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('telescope').setup({
				defaults = {
					layout_config = {
						horizontal = { preview_width = 0.6 },
					},
				},
				pickers = {
					find_files = {
						previewer = false,
						find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
					},
				},
			})
		end,
	})
	use({
		'nvim-treesitter/nvim-treesitter',
		require = 'windwp/nvim-ts-autotag',
		run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = 'maintained',
				ignore_install = { 'haskell' },
				highlight = { enable = true },
				autotag = { enable = true },
				indent = { enable = true },
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
				update_cwd = true,
				git = { ignore = false },
				filters = { custom = { '.git' } },
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
					vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc or '' })
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
			local builtins = require('null-ls').builtins

			require('null-ls').setup({
				sources = {
					builtins.code_actions.xo,
					builtins.diagnostics.xo,
					builtins.formatting.fish_indent,
					builtins.formatting.prettierd.with({ extra_filetypes = { 'svelte', 'jsonc' } }),
					builtins.formatting.shfmt.with({ extra_filetypes = { 'bash', 'sh', 'zsh' } }),
					builtins.formatting.stylua,
					builtins.formatting.gofumpt,
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
			vim.opt.completeopt = 'menu,menuone,noselect'

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
