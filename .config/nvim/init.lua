vim.g.mapleader = ' '
vim.keymap.set('n', '<space>', '<nop>', { silent = true })

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
end

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
vim.g.nvim_tree_icons = { folder = { default = '●', empty = '◌', empty_open = '○', open = '○' } }
vim.g.nvim_tree_show_icons = { folders = 1, files = 0 }
require('nvim-tree').setup({
	actions = { open_file = { quit_on_open = true } },
	filters = { custom = { '.git$' } },
	git = { ignore = false },
	view = {
		mappings = { list = { { key = 'd', action = 'trash' }, { key = 'D', action = 'remove' } } },
		side = 'right',
	},
})
vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<cr>', { silent = true }) -- toggle explorer

vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
vim.opt.statusline = ' %f %M %= %l:%c ♥ '
vim.opt.shortmess:append('c')

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

vim.keymap.set('i', 'jk', '<esc>', { silent = true }) -- escape alternative

-- Movements
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { silent = true }) -- move through wrapped lines
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { silent = true }) -- move through wrapped lines
vim.keymap.set('v', '<', '<gv', { silent = true }) -- dedent (keep selection)
vim.keymap.set('v', '>', '>gv', { silent = true }) -- indent (keep selection)

-- Goto
vim.keymap.set('n', 'g.', '`.', { silent = true }) -- goto last modification
vim.keymap.set('n', 'go', '<c-o>', { silent = true }) -- goto previous position
vim.keymap.set('n', 'gn', '<c-i>', { silent = true }) -- goto next position
vim.keymap.set('n', 'gp', '<c-^>', { silent = true }) -- goto previous buffer
vim.keymap.set('n', 'gm', '%', { silent = true }) -- goto matching character: '()', '{}', '[]'

-- Window
vim.keymap.set('n', '<leader>wh', '<c-w><c-h>', { silent = true }) -- jump to split to the left
vim.keymap.set('n', '<leader>wj', '<c-w><c-j>', { silent = true }) -- jump to split below
vim.keymap.set('n', '<leader>wk', '<c-w><c-k>', { silent = true }) -- jump to split above
vim.keymap.set('n', '<leader>wl', '<c-w><c-l>', { silent = true }) -- jump to split to the right
vim.keymap.set('n', '<leader>wr', '<c-w><c-r>', { silent = true }) -- swap split positions
vim.keymap.set('n', '<leader>ww', '<c-w><c-w>', { silent = true }) -- focus next window
vim.keymap.set('n', '<leader>wo', ':only<cr>', { silent = true }) -- close other windows

-- Equally resize splits
vim.api.nvim_create_autocmd('VimResized', { pattern = '*', command = 'tabdo wincmd =' })

-- Stop 'o' continuing comments
vim.api.nvim_create_autocmd('BufEnter', { pattern = '*', command = 'setlocal formatoptions-=o' })

--- Search
packer.use({ 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' })
require('telescope').setup({
	defaults = { layout_config = { horizontal = { preview_width = 0.6 } } },
	pickers = {
		find_files = {
			theme = 'dropdown',
			previewer = false,
			find_command = { 'fd', '-t', 'f', '-H', '-E', '.git', '--strip-cwd-prefix' },
		},
	},
})

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set('n', '<esc>', ':noh<cr>', { silent = true }) -- clear search highlights
vim.keymap.set('n', '*', '*N', { silent = true }) -- search word under cursor (keep position)
vim.keymap.set('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { silent = true }) -- search selection (keep position)
vim.keymap.set('n', '<leader>f', ':Telescope find_files<cr>', { silent = true }) -- search files
vim.keymap.set('n', '<leader>/', ':Telescope live_grep<cr>', { silent = true }) -- search text

--- LSP
packer.use({ 'neovim/nvim-lspconfig', requires = 'folke/lua-dev.nvim' })
local function on_attach(_, bufnr)
	vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = bufnr, silent = true })
	vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { buffer = bufnr, silent = true })
	vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = bufnr, silent = true })
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, silent = true })
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, silent = true })
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, silent = true })
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, silent = true })
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').sumneko_lua.setup(
	require('lua-dev').setup({ lspconfig = { on_attach = on_attach, capabilities = capabilities } })
)

-- Language servers to setup. Servers must be available in your path.
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = { 'cssls', 'gopls', 'html', 'jsonls', 'svelte', 'tailwindcss', 'tsserver', 'volar' }
for _, server in ipairs(servers) do
	require('lspconfig')[server].setup({ on_attach = on_attach, capabilities = capabilities })
end

packer.use({ 'jose-elias-alvarez/null-ls.nvim', requires = 'nvim-lua/plenary.nvim' })
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
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { silent = true }) -- goto previous diagnostic
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { silent = true }) -- goto next diagnostic
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { silent = true }) -- show diagnostic message

vim.diagnostic.config({ virtual_text = false })

--- Completions
packer.use({ 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip' } })
local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<c-space>'] = cmp.mapping.complete(),
		['<cr>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
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
