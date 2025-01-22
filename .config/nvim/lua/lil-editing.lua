---
--- lil-editing.lua
--- https://github.com/mvllow/lilvim
---
--- Setup general editing options and keymaps
---
---@keymaps
--- |NORMAL|
--- <leader>y : Copy to clipboard
--- <leader>p : Paste from clipboard
--- j/k       : Navigate wrapped lines
--- gcc       : Comment line
--- |VISUAL|
--- gc        : Comment selection

-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Continue wrapped lines with matching indentation
vim.o.breakindent = true
vim.o.linebreak = true
-- Visually show indented lines, e.g. if this line were to naturally wrap
-- \\you would see "\\" as demonstrated at the start of this line
vim.o.showbreak = [[\\]]

-- Persistent undo between sessions
vim.o.undofile = true

-- Start scrolling before reaching the edge of the screen
vim.o.scrolloff = 3

-- Copy and paste via clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Navigate through wrapped lines via j/<down>, k/<up>
vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
vim.keymap.set({ "n", "v" }, "<down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })

vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("LilEditing", { clear = true }),
	command = "tabdo wincmd =",
	desc = "Maintain window ratios after resize",
})
