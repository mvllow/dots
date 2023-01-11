local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	if opts.silent == nil then
		opts.silent = true
	end
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "

-- Improved searching.
map("n", "<esc>", ":noh<cr>", { desc = "Clear search highlights" })
map("n", "*", "*N", { desc = "Search under cursor" })
map("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { desc = "Search selection" })

-- Move through wrapped lines.
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

-- Bubble lines.
map("n", "<c-j>", ":m .+1<cr>==")
map("n", "<c-k>", ":m .-2<cr>==")
map("v", "<c-j>", ":m '>+1<cr>gv=gv")
map("v", "<c-k>", ":m '<-2<cr>gv=gv")

-- Keep selection when indenting.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Reindent entire file.
map("n", "=", "mxggVG=`x")

-- Substitute current word.
map("n", "S", ":%s/<c-r><c-w>//g<left><left>", { silent = false })

-- Goto helpers.
map("n", "go", "<c-o>", { desc = "Goto previous position" })
map("n", "gO", "<c-i>", { desc = "Goto next position" })
map("n", "gp", "<c-^>", { desc = "Goto previously focused buffer" })
map({ "n", "v" }, "gm", "%", { desc = "Goto matching pair" })

-- Window controls.
map("n", "<c-w>h", "<leader>wh", { desc = "Focus window to the left" })
map("n", "<c-w>j", "<leader>wj", { desc = "Focus window below" })
map("n", "<c-w>k", "<leader>wk", { desc = "Focus window above" })
map("n", "<c-w>l", "<leader>wl", { desc = "Focus window to the right" })
map("n", "<c-w>r", "<leader>wr", { desc = "Swap window positions" })
