local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
else
	require('impatient')
end

local function map(mode, lhs, rhs, opts)
	opts = opts or { noremap = true, silent = true }
	return vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- use <space> as leader
map('n', '<space>', '<nop>')
vim.g.mapleader = ' '

-- general
map('i', 'jk', '<esc>')
map('n', '<esc>', ':noh<cr>')

-- splits
map('n', '<c-h>', '<c-w><c-h>')
map('n', '<c-j>', '<c-w><c-j>')
map('n', '<c-k>', '<c-w><c-k>')
map('n', '<c-l>', '<c-w><c-l>')

-- hop between previous and current buffer
map('n', '<c-p>', '<c-^>')

-- move through wrap lines
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- reselect visual after indent
map('v', '<', '<gv')
map('v', '>', '>gv')

-- search word under cursor (or selection)
map('n', '*', '*N')
map('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])

-- buffers
map('n', 'L', ':bnext<cr>')
map('n', 'H', ':bprev<cr>')
map('n', '<leader>d', ':bdelete<cr>')
map('n', '<leader>bo', [[:silent %bd|e#|bd#<cr>'"]]) -- close all but current
map('n', '<leader>bf', ':lua vim.lsp.buf.formatting_sync(nil, 1000)<cr>')

-- buffers (via barbar)
map('n', 'L', ':BufferNext<cr>')
map('n', 'H', ':BufferPrevious<cr>')
map('n', '<leader>d', ':BufferClose<cr>')
map('n', '<leader>bo', ':BufferCloseAllButCurrent<cr>')

-- plugin manager (wbthomason/packer.nvim)
map('n', '<leader>pc', '<cmd>PackerCompile<cr>')
map('n', '<leader>ps', '<cmd>PackerSync<cr>')

-- explorer (kyazdani42/nvim-tree.lua)
map('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

-- fuzzy search (nvim-telescope/telescope.nvim)
map(
	'n',
	'<leader>f',
	[[:lua require('telescope.builtin').find_files(require'telescope.themes'.get_dropdown({winblend=10,previewer=false}))<cr>]]
)
map(
	'n',
	'<leader>st',
	[[:lua require('telescope.builtin').live_grep({layout_config={preview_width=0.6}})<cr>]]
)
map(
	'n',
	'<leader>sr',
	[[:lua require('telescope.builtin').registers(require'telescope.themes'.get_dropdown({winblend=10}))<cr>]]
)

local tab_width = 4
vim.opt.shiftwidth = tab_width
vim.opt.tabstop = tab_width
vim.opt.softtabstop = tab_width
vim.opt.mouse = 'a' -- enable mouse
vim.opt.hidden = true -- allow hidden unsaved buffers
vim.opt.breakindent = true -- match wrapped indent
vim.opt.undofile = true -- save undo history
vim.opt.ignorecase = true -- case insensitive search...
vim.opt.smartcase = true -- ...unless capital in search
vim.opt.updatetime = 250 -- update editor more frequently
vim.opt.termguicolors = true -- more colors
vim.opt.pumheight = 10 -- popup menu height
vim.opt.scrolloff = 5 -- scroll before reaching edge of screen
vim.opt.shortmess:append('c') -- shorter messages
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 0
vim.opt.statusline = '%f %M %= %l:%c'

vim.cmd([[autocmd BufEnter * setlocal formatoptions-=o]])
vim.cmd([[autocmd VimResized * tabdo wincmd =]])

require('packer').startup(function(use)
	use('wbthomason/packer.nvim')

	-- TODO: Remove impatient.nvim (and require at the top) once merged upstream
	use('lewis6991/impatient.nvim')

	use({
		'rose-pine/neovim',
		config = function()
			vim.g.rose_pine_disable_italics = true
			vim.cmd('colorscheme rose-pine')
		end,
	})
	use({
		'mvllow/modes.nvim',
		config = function()
			require('modes').setup()
		end,
	})
	use({
		'romgrk/barbar.nvim',
		config = function()
			vim.g.bufferline = {
				animation = false,
				icon_close_tab = '×',
				icon_close_tab_modified = '♥',
				icon_separator_active = '',
				icon_separator_inactive = '',
				icons = false,
			}
		end,
	})
	use({
		'lewis6991/gitsigns.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('gitsigns').setup()
		end,
	})
	use('editorconfig/editorconfig-vim')
	use('tpope/vim-commentary')
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = 'maintained',
				ignore_install = { 'haskell' },
				indent = {
					enable = true,
				},
				highlight = {
					enable = true,
				},
				autopairs = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})
		end,
	})
	use({
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup()
			require('nvim-autopairs.completion.cmp').setup({
				map_cr = true,
				map_complete = true,
				auto_select = false,
			})
		end,
	})
	use('windwp/nvim-ts-autotag')
	use('JoosepAlviste/nvim-ts-context-commentstring')
	use({ 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' })
	use({
		'neovim/nvim-lspconfig',
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			local function on_attach(client, bufnr)
				client.resolved_capabilities.document_formatting = false

				vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

				local function buf_map(mode, lhs, rhs, opts)
					opts = opts or { noremap = true, silent = true }
					vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
				end

				buf_map('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
				buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
				buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
				buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
				buf_map('n', 'gl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>')
				buf_map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')
				buf_map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
				buf_map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
				buf_map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
			end

			local function setup_servers()
				require('lspinstall').setup()

				local servers = require('lspinstall').installed_servers()
				for _, server in pairs(servers) do
					local config = {
						capabilities = capabilities,
						on_attach = on_attach,
					}

					if server == 'lua' then
						config = vim.tbl_extend('force', config, require('lua-dev').setup())
					end

					require('lspconfig')[server].setup(config)
				end
			end

			setup_servers()

			require('lspinstall').post_install_hook = function()
				setup_servers()
				vim.cmd('bufdo e')
			end

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
	use('folke/lua-dev.nvim')
	use('kabouzeid/nvim-lspinstall')
	use({
		'jose-elias-alvarez/null-ls.nvim',
		requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
		config = function()
			local null_ls = require('null-ls')

			null_ls.config({
				sources = {
					null_ls.builtins.formatting.elm_format,
					null_ls.builtins.formatting.fish_indent,
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.rufo,
					null_ls.builtins.formatting.shfmt.with({
						filetypes = { 'bash', 'sh', 'zsh' },
					}),
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
		config = function()
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
							:sub(col, col)
							:match('%s')
						== nil
			end

			local cmp = require('cmp')
			local luasnip = require('luasnip')
			require('luasnip/loaders/from_vscode').lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				preselect = cmp.PreselectMode.None,
				mapping = {
					['<c-n>'] = cmp.mapping.select_next_item(),
					['<c-p>'] = cmp.mapping.select_prev_item(),
					['<tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, {
						'i',
						's',
					}),

					['<s-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {
						'i',
						's',
					}),
					['<c-space>'] = cmp.mapping.complete(),
				},
				sources = {
					{ name = 'buffer', priority = 7 },
					{ name = 'path', priority = 6 },
					{ name = 'nvim_lsp', priority = 9 },
					{ name = 'luasnip', priority = 8 },
				},
			})
		end,
	})
	use('hrsh7th/cmp-buffer')
	use('hrsh7th/cmp-path')
	use({ 'L3MON4D3/LuaSnip', requires = 'rafamadriz/friendly-snippets' })
	use('saadparwaiz1/cmp_luasnip')
	use('hrsh7th/cmp-nvim-lsp')
	use({
		'kyazdani42/nvim-tree.lua',
		config = function()
			vim.g.nvim_tree_git_hl = 1
			vim.g.nvim_tree_icons = {
				default = '  ',
				symlink = '  ',
				folder = {
					default = '>',
					empty = '>',
					empty_open = '▼',
					open = '▼',
					symlink = '↔',
				},
			}
			vim.g.nvim_tree_ignore = { '.git' }
			vim.g.nvim_tree_quit_on_open = 1
			vim.g.nvim_tree_show_icons = { folders = 1, files = 0 }
			vim.g.nvim_tree_symlink_arrow = '↔'
			require('nvim-tree').setup({
				auto_close = true,
				disable_netrw = true,
				view = {
					side = 'right',
				},
			})
		end,
	})
	use({
		'norcalli/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup({ '*' }, { names = false })
		end,
	})
end)
