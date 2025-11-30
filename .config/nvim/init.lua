require('vim._extui').enable({})

vim.g.mapleader = ' '

vim.cmd.colorscheme('bloom')

vim.o.undofile       = true
vim.o.scrolloff      = 5
vim.o.pumheight      = 5
vim.o.colorcolumn    = '+1'
vim.o.signcolumn     = 'yes'

vim.o.breakindent    = true
vim.o.breakindentopt = 'list:-1'
vim.o.linebreak      = true
vim.o.showbreak      = '↪'

vim.o.tabstop        = 8
vim.o.shiftwidth     = 8

vim.o.ignorecase     = true
vim.o.smartcase      = true

vim.o.spell          = true
vim.o.spelllang      = 'en,it'

vim.o.completeopt    = 'menuone,noselect,popup'

vim.cmd('packadd nvim.undotree')

vim.pack.add({
	{ src = 'https://github.com/mvllow/lilvim',                   version = 'lil-toggle' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/stevearc/conform.nvim',
	'https://github.com/tpope/vim-dadbod',
	'https://github.com/kristijanhusak/vim-dadbod-ui',
	'https://github.com/tpope/vim-fugitive',
	'https://github.com/tpope/vim-sleuth',
	'https://github.com/vim-test/vim-test',
	'https://github.com/nvim-mini/mini.diff',
	'https://github.com/nvim-mini/mini.files',
	'https://github.com/nvim-mini/mini.pick',
	'https://github.com/sschleemilch/slimline.nvim',
})
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function()
		vim.cmd('TSUpdate')
	end,
})

vim.keymap.set('n', '<c-d>', vim.diagnostic.setqflist)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

vim.keymap.set({ 'n', 'v' }, 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ 'n', 'v' }, '<up>', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ 'n', 'v' }, '<down>', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })

vim.keymap.set('n', '*', '*N')
vim.keymap.set('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])
vim.keymap.set('n', 'S', ':%s/<c-r><c-w>/<c-r><c-w>/g<left><left>')
vim.keymap.set('v', 'S', '"zy:let @"=@0<cr>:%s/<c-r>z/<c-r>z/g<left><left>')

vim.keymap.set({ 'n', 'v' }, '<c-j>', ':cnext<cr>')
vim.keymap.set({ 'n', 'v' }, '<c-k>', ':cprev<cr>')

vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')

vim.keymap.set('c', '<c-v>', '<home><s-right><c-w>vs<end>', { desc = 'Change command to :vs' })
vim.keymap.set('c', '<c-s>', '<home><s-right><c-w>vs<end>', { desc = 'Change command to :sp' })

vim.keymap.set('n', '<leader>e', ':Explore<cr>', { desc = 'Explore' })
vim.keymap.set('n', '<leader>f', ':find ', { desc = 'Find file' })
vim.keymap.set('n', '<leader>/', ':grep ', { desc = 'Find in files' })

vim.keymap.set('n', '<leader>S', function()
	vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, { desc = 'Scratch buffer' })

-- Automatically setup treesitter when editing a supported filetype
vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		local available_langs = require('nvim-treesitter.config').get_available()

		if not vim.tbl_contains(available_langs, lang) then
			return
		end

		require('nvim-treesitter').install(lang):await(function()
			pcall(vim.treesitter.start)
			vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			vim.bo.indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
		end)
	end,
})

vim.lsp.enable({
	'angularls',
	'astro',
	'eslint',
	'gopls',
	'lua_ls',
	'svelte',
	'tailwindcss',
	'ts_ls',
	-- 'tsgo',
})

if vim.uv.fs_stat(vim.fn.getcwd() .. '/nx.json') then
	vim.g['test#javascript#runner'] = 'nx'
end

require('lil-lsp')
require('lil-search')
require('lil-stats')
require('lil-subs')

vim.g.lil_toggle_prefix = ','
require('lil-toggle')
LilToggle('a', 'autocomplete')
LilToggle('b', 'background')
LilToggle('c', 'cmdheight')
LilToggle('d', 'diagnostic')
LilToggle('f', 'FormatOnSave') -- For one-off, use `:noauto w`
LilToggle('gc', 'document_color')
LilToggle('gd', function()
	local ok, mini_diff = pcall(require, 'mini.diff')
	if ok then mini_diff.toggle_overlay() end
end)
LilToggle('gh', 'inlay_hint')
LilToggle('l', 'list')
LilToggle('m', 'laststatus')
LilToggle('n', 'number')
LilToggle('q', 'quickfix')
LilToggle('s', 'spell')
LilToggle('w', 'wrap')

require('conform').setup({
	notify_on_error = false,
	default_format_opts = { lsp_format = 'fallback' },
	formatters_by_ft = {
		fish = { 'fish_indent' },
		go = { 'goimports', 'gofmt' },
		sh = { 'shfmt' },
		javascript = { 'prettier' },
		javascriptreact = { 'prettier' },
		typescript = { 'prettier' },
		typescriptreact = { 'prettier' },
		vue = { 'prettier' },
		css = { 'prettier' },
		scss = { 'prettier' },
		less = { 'prettier' },
		html = { 'prettier' },
		htmlangular = { 'prettier' },
		json = { 'prettier' },
		jsonc = { 'prettier' },
		graphql = { 'prettier' },
		markdown = { 'prettier' },
		yaml = { 'prettier' },
		astro = { 'prettier' },
		svelte = { 'prettier' },
	},
})

vim.o.formatexpr = 'v:lua.require"conform".formatexpr()'

vim.api.nvim_create_autocmd('BufWritePre', {
	group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true }),
	pattern = '*',
	callback = function()
		require('conform').format({ timeout_ms = 1000 })
	end,
})

require('mini.diff').setup()

local mini_files = require('mini.files')
mini_files.setup({ options = { permanent_delete = false } })
vim.keymap.set('n', '<leader>e', function()
	mini_files.open(vim.api.nvim_buf_get_name(0))
end, { desc = 'File explorer' })

local mini_pick = require('mini.pick')
local choose_all = function()
	local mappings = mini_pick.get_picker_opts().mappings
	vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
end
mini_pick.setup({ mappings = { choose_all = { char = '<c-q>', func = choose_all } } })
vim.keymap.set('n', '<leader>f', ':Pick files<cr>', { desc = 'Search files' })
vim.keymap.set('n', '<leader>/', ':Pick grep_live<cr>', { desc = 'Search text' })
vim.keymap.set('n', '<leader>.', ':Pick resume<cr><space><bs>', { desc = 'Resume search' })

vim.o.ruler = false
require('slimline').setup({ style = 'fg' })
