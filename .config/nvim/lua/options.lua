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
vim.opt.pumheight = 5
vim.opt.wrap = false
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.statusline = ' %f %M %= %l:%c ♥ '
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·' }

vim.cmd('autocmd BufEnter * setlocal formatoptions-=o')
vim.cmd('autocmd VimResized * tabdo wincmd =')
vim.cmd('autocmd BufRead,BufNewFile *.json set ft=jsonc')
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

vim.diagnostic.config({
	virtual_text = false,
})

local signs = { Error = '●', Warn = '●', Hint = '●', Info = '●' }
for type, icon in pairs(signs) do
	local hl = 'DiagnosticSign' .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
