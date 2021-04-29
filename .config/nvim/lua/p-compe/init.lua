local set_keymap = vim.api.nvim_set_keymap
local opts = {silent = true, expr = true}

vim.o.completeopt = 'menuone,noselect'

require'compe'.setup {
	enabled = true,
	autocomplete = true,
	documentation = true,
	source = {
		path = {},
		buffer = {},
		calc = {},
		vsnip = {},
		nvim_lsp = {},
		treesitter = {},
		spell = {},
		emoji = {filetypes = {'markdown', 'text'}}
	}
}

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
		return true
	else
		return false
	end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t '<c-n>'
	elseif vim.fn.call('vsnip#available', {1}) == 1 then
		return t '<plug>(vsnip-expand-or-jump)'
	elseif check_back_space() then
		return t '<tab>'
	else
		return vim.fn['compe#complete']()
	end
end

_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t '<c-p>'
	elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
		return t '<plug>(vsnip-jump-prev)'
	else
		return t '<s-tab>'
	end
end

set_keymap('i', '<tab>', 'v:lua.tab_complete()', opts)
set_keymap('s', '<tab>', 'v:lua.tab_complete()', opts)
set_keymap('i', '<s-tab>', 'v:lua.s_tab_complete()', opts)
set_keymap('s', '<s-tab>', 'v:lua.s_tab_complete()', opts)
set_keymap('i', '<cr>', [[compe#confirm('<cr>')]], opts)
set_keymap('i', '<c-space>', 'compe#complete()', opts)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = true,
    signs = true,
  }
)
vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
