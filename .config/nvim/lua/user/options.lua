vim.cmd.colorscheme("un")

local tab_width = 8

vim.opt.guicursor = ""
vim.opt.pumheight = 8
vim.opt.shortmess:append("c")
vim.opt.shiftwidth = tab_width
vim.opt.softtabstop = tab_width
vim.opt.tabstop = tab_width
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.statusline = " %f %m %= %l:%c ♥ "
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.breakindent = true

vim.api.nvim_create_autocmd("BufEnter", {
	command = "setlocal formatoptions-=o",
})

vim.api.nvim_create_autocmd("VimResized", {
	command = "tabdo wincmd =",
})

vim.diagnostic.config({
	virtual_text = false,
})

local signs = { "Error", "Warn", "Hint", "Info" }
for _, type in pairs(signs) do
	local hl = string.format("DiagnosticSign%s", type)
	vim.fn.sign_define(hl, { text = "●", texthl = hl, numhl = hl })
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})
