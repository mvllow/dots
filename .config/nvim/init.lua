local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
else
	pcall(require, 'impatient')
end

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '
map('n', '<space>', '<nop>', opts)
map('i', 'jk', '<esc>', opts)
map('n', 'j', 'gj', opts) -- move through wrapped lines
map('n', 'k', 'gk', opts)
map('n', '<esc>', ':noh<cr>', opts) -- clear highlights on escape
map('n', '<c-h>', '<c-w><c-h>', opts) -- split management
map('n', '<c-j>', '<c-w><c-j>', opts)
map('n', '<c-k>', '<c-w><c-k>', opts)
map('n', '<c-l>', '<c-w><c-l>', opts)
map('v', '<', '<gv', opts) -- reselect after indenting in visual mode
map('v', '>', '>gv', opts)
map('n', '*', '*N', opts) -- keep `*` selection on current word
map('v', '*', [[y/\V<c-r>=escape(@",'/\', opts)<cr><cr>N]]) -- mimic normal mode `*` selection (and keep on current word)
map('n', '<leader>pc', ':PackerCompile<cr>', opts)
map('n', '<leader>ps', ':PackerSync<cr>', opts)
map('n', 'L', ':bnext<cr>', opts)
map('n', 'H', ':bprev<cr>', opts)
map('n', '<leader>e', ':NvimTreeToggle<cr>', opts)
map('n', '<leader>h', ':TSHighlightCapturesUnderCursor<cr>', opts)
map('n', '<leader>f', [[:lua require('telescope.builtin').find_files()<cr>]], opts)
map('n', '<leader>st', [[:lua require('telescope.builtin').live_grep()<cr>]], opts)
map('n', '<leader>d', ':BufferClose<cr>', opts) -- BarBar: close current buffer
map('n', '<leader>bo', ':BufferCloseAllButCurrent<cr>', opts) -- BarBar: close other buffers

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
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.pumheight = 10
vim.opt.wrap = false
vim.opt.laststatus = 2
vim.opt.statusline = '%f %M %= %l:%c ♥'

vim.diagnostic.config({ virtual_text = false })

vim.cmd('autocmd BufEnter * setlocal formatoptions-=o')
vim.cmd('autocmd VimResized * tabdo wincmd =')
vim.cmd('autocmd BufRead,BufNewFile *.json set ft=jsonc')

require('packer').startup(function(use)
	use('wbthomason/packer.nvim')
	use('lewis6991/impatient.nvim')
	use('editorconfig/editorconfig-vim')
	use('b0o/schemastore.nvim')
	use('tpope/vim-commentary')
	use('tpope/vim-surround')
	use('tpope/vim-repeat')
	use({
		'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('telescope').setup({
				defaults = {
					winblend = 10,
					layout_config = { horizontal = { preview_width = 0.6 } },
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
				icon_separator_active = '',
				icon_separator_inactive = '',
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
		requires = { 'folke/lua-dev.nvim' },
		config = function()
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
				buf_map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
				buf_map('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
				buf_map('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<cr>')
				buf_map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
				buf_map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			local lspconfig = require('lspconfig')
			lspconfig.sumneko_lua.setup(require('lua-dev').setup({
				lspconfig = {
					cmd = {
						vim.fn.getenv('HOME')
							.. '/.local/share/lua-language-server/bin/macOS/lua-language-server',
					},
					on_attach = on_attach,
					capabilities = capabilities,
				},
			}))

			local servers = { 'html', 'jsonls', 'cssls', 'tailwindcss', 'tsserver', 'svelte' }
			for _, server in ipairs(servers) do
				local opts = {}

				if server == 'jsonls' then
					opts = {
						filetypes = { 'json', 'jsonc' },
						settings = { json = { schemas = require('schemastore').json.schemas() } },
					}
				end

				lspconfig[server].setup(vim.tbl_deep_extend('force', {
					on_attach = on_attach,
					capabilities = capabilities,
				}, opts))
			end
		end,
	})
	use({
		'jose-elias-alvarez/null-ls.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function()
			local null_ls = require('null-ls')
			local prettier_filetypes = null_ls.builtins.formatting.prettier.filetypes
			table.insert(prettier_filetypes, 'jsonc')
			table.insert(prettier_filetypes, 'svelte')

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.fish_indent,
					null_ls.builtins.formatting.prettierd.with({ filetypes = prettier_filetypes }),
					null_ls.builtins.formatting.shfmt.with({ filetypes = { 'bash', 'sh', 'zsh' } }),
					null_ls.builtins.formatting.stylua,
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
				sources = {
					{ name = 'nvim_lsp' },
				},
			})
		end,
	})
end)
