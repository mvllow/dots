---
--- lil-search.lua
--- https://github.com/mvllow/lilvim
---
--- Setup file management and search
---
---@commands
--- :Explore : Open file explorer
--- :FZF     : Fuzzy search files
--- :grep    : Fuzzy search file contents
---
---@keymaps
--- |NORMAL|
--- <leader>e : Open file explorer
--- <leader>f : Fuzzy find files
--- |NETRW|
--- <cr>      : Open file
--- %         : Create a new file
--- d         : Create a new directory
--- D         : Delete a file or empty directory
--- |FZF|
--- <cr>      : Open file
--- <tab>     : Mark file
---
---@see lil-grep.lua
---@see lil-quickfix.lua
---

-- Case-insensitive search, unless search contains uppercase
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set("n", "<leader>e", ":Ex<cr>", { desc = "Open file explorer" })

if vim.fn.executable("fzf") == 1 then
	local fzf_bin_path = vim.fn.exepath("fzf")
	if fzf_bin_path ~= "" then
		local fzf_plugin_path = string.gsub(fzf_bin_path, "bin", "opt")
		vim.opt.runtimepath:append(fzf_plugin_path)
		vim.keymap.set("n", "<leader>f", ":FZF<cr>", { desc = "Fuzzy find" })
	end
end
