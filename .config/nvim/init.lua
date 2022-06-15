local function map(mode, lhs, rhs, opts)
	opts = vim.tbl_extend('force', opts or {}, { silent = true })
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = ' '
map('n', '<space>', '<nop>')

local install_path = vim.fn.stdpath('data')
	.. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute(
		'!git clone --depth 1 https://github.com/wbthomason/packer.nvim '
			.. install_path
	)
end

map('n', '<leader>pc', ':PackerCompile<cr>')
map('n', '<leader>ps', ':PackerSync<cr>')

local packer = require('packer')
packer.init()
packer.use('wbthomason/packer.nvim')

--- Interface
packer.use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
require('nvim-treesitter.configs').setup({
	ensure_installed = 'all',
	ignore_install = { 'phpdoc' },
	highlight = { enable = true },
})

packer.use({ 'rose-pine/neovim', as = 'rose-pine' })
require('rose-pine').setup({ disable_italics = true })
vim.cmd('colorscheme rose-pine')

packer.use('kyazdani42/nvim-tree.lua')
require('nvim-tree').setup({
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	filters = {
		custom = { '.git$' },
	},
	git = {
		ignore = false,
	},
	renderer = {
		icons = {
			show = {
				file = false,
				folder = false,
				folder_arrow = false,
				git = false,
			},
		},
	},
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
map('n', '<leader>e', ':NvimTreeFindFileToggle<cr>') -- toggle explorer

vim.opt.colorcolumn = { 80 }
vim.opt.cmdheight = 0
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
vim.opt.statusline = ' %f %M %= %l:%c ♥ '
vim.opt.updatetime = 50
vim.opt.shortmess:append('c')
vim.opt.wildmode = { 'longest', 'list', 'full' }

--- Editing
packer.use('editorconfig/editorconfig-vim')
packer.use('numToStr/Comment.nvim')
require('comment').setup()

vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.breakindent = true

map('i', 'jk', '<esc>') -- escape alternative

-- Movements
map({ 'n', 'v' }, 'j', 'gj') -- move through wrapped lines
map({ 'n', 'v' }, 'k', 'gk') -- move through wrapped lines
map('v', '<', '<gv') -- dedent (keep selection)
map('v', '>', '>gv') -- indent (keep selection)

-- Goto
map('n', 'g.', '`.') -- goto last modification
map('n', 'go', '<c-o>') -- goto previous position
map('n', 'gn', '<c-i>') -- goto next position
map('n', 'gp', '<c-^>') -- goto previous buffer
map('n', 'gm', '%') -- goto matching character: '()', '{}', '[]'

-- Window
map('n', '<leader>wh', '<c-w><c-h>') -- jump to split to the left
map('n', '<leader>wj', '<c-w><c-j>') -- jump to split below
map('n', '<leader>wk', '<c-w><c-k>') -- jump to split above
map('n', '<leader>wl', '<c-w><c-l>') -- jump to split to the right
map('n', '<leader>wr', '<c-w><c-r>') -- swap split positions
map('n', '<leader>ww', '<c-w><c-w>') -- focus next window
map('n', '<leader>wo', ':only<cr>') -- close other windows

-- Equally resize splits
vim.api.nvim_create_autocmd(
	'VimResized',
	{ pattern = '*', command = 'tabdo wincmd =' }
)

-- Stop 'o' continuing comments
vim.api.nvim_create_autocmd(
	'BufEnter',
	{ pattern = '*', command = 'setlocal formatoptions-=o' }
)

--- Search
packer.use({
	'nvim-telescope/telescope.nvim',
	requires = 'nvim-lua/plenary.nvim',
})
require('telescope').setup({
	defaults = { layout_config = { horizontal = { preview_width = 0.6 } } },
	pickers = {
		find_files = {
			theme = 'dropdown',
			previewer = false,
			find_command = {
				'fd',
				'-t',
				'f',
				'-H',
				'-E',
				'.git',
				'--strip-cwd-prefix',
			},
		},
	},
})

vim.opt.ignorecase = true
vim.opt.smartcase = true

map('n', '<esc>', ':noh<cr>') -- clear search highlights
map('n', '*', '*N') -- search word under cursor (keep position)
map('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]]) -- search selection (keep position)
map('n', '<leader>f', ':Telescope find_files<cr>') -- search files
map('n', '<leader>/', ':Telescope live_grep<cr>') -- search text

--- LSP
packer.use({ 'neovim/nvim-lspconfig', requires = 'folke/lua-dev.nvim' })
local function on_attach(_, bufnr)
	map('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = bufnr })
	map('n', '<leader>a', vim.lsp.buf.code_action, { buffer = bufnr })
	map('n', '<leader>r', vim.lsp.buf.rename, { buffer = bufnr })
	map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
	map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
	map('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })
	map('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(
	vim.lsp.protocol.make_client_capabilities()
)

require('lspconfig').sumneko_lua.setup(require('lua-dev').setup({
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
	'svelte',
	'tailwindcss',
	'tsserver',
}
for _, server in ipairs(servers) do
	require('lspconfig')[server].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

packer.use({
	'jose-elias-alvarez/null-ls.nvim',
	requires = 'nvim-lua/plenary.nvim',
})
local null_ls = require('null-ls')
null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.xo,
		null_ls.builtins.diagnostics.xo,
		null_ls.builtins.formatting.fish_indent,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.prettierd.with({
			extra_filetypes = { 'svelte', 'jsonc' },
			{ extra_args = { '--plugin-search-dir', '.' } },
		}),
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.stylua,
	},
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

map('n', '[d', vim.diagnostic.goto_prev) -- goto previous diagnostic
map('n', ']d', vim.diagnostic.goto_next) -- goto next diagnostic
map('n', 'gl', vim.diagnostic.open_float) -- show diagnostic message

vim.diagnostic.config({
	virtual_text = false,
})

--- Completions
packer.use({
	'hrsh7th/nvim-cmp',
	requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip' },
})
local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
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
	}),
	sources = { { name = 'nvim_lsp' } },
})

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.pumheight = 3
