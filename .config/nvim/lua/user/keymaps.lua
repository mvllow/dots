local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent == nil and true or opts.silent
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
map("v", "<", "<gv")
map("v", ">", ">gv")

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
map("n", "<leader>wh", "<c-w>h", { desc = "Focus window to the left" })
map("n", "<leader>wj", "<c-w>j", { desc = "Focus window below" })
map("n", "<leader>wk", "<c-w>k", { desc = "Focus window above" })
map("n", "<leader>wl", "<c-w>l", { desc = "Focus window to the right" })
map("n", "<leader>wr", "<c-w>r", { desc = "Swap window positions" })
