vim.opt.guicursor = ""
vim.opt.pumheight = 8
vim.opt.shortmess:append("c")
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.cmdheight = 0
vim.opt.statusline = " %f %m %= %l:%c ♥ "
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.api.nvim_create_autocmd("BufEnter", { command = "setlocal formatoptions-=o" })
vim.api.nvim_create_autocmd("VimResized", { command = "tabdo wincmd =" })

vim.diagnostic.config({ virtual_text = false })

local signs = { "Error", "Warn", "Hint", "Info" }
for _, type in pairs(signs) do
	local hl = string.format("DiagnosticSign%s", type)
	vim.fn.sign_define(hl, { text = "●", texthl = hl, numhl = hl })
end