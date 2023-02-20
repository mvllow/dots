local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent == nil and true or opts.silent
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "

-- Improve search behaviour
map("n", "<esc>", ":noh<cr>", { desc = "Clear search highlights" })
map("n", "*", "*N", { desc = "Search under cursor" })
map("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { desc = "Search selection" })

-- Move through wrapped lines
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

-- Keep selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Substitute current word
map("n", "S", ":%s/<c-r><c-w>//g<left><left>", { silent = false })

-- Goto
map("n", "go", "<c-o>", { desc = "Goto previous position" })
map("n", "gO", "<c-i>", { desc = "Goto next position" })
map("n", "gp", "<c-^>", { desc = "Goto previously focused buffer" })
map({ "n", "v" }, "gm", "%", { desc = "Goto matching pair" })

-- Window
map("n", "<leader>wh", "<c-w>h", { desc = "Focus window to the left" })
map("n", "<leader>wj", "<c-w>j", { desc = "Focus window below" })
map("n", "<leader>wk", "<c-w>k", { desc = "Focus window above" })
map("n", "<leader>wl", "<c-w>l", { desc = "Focus window to the right" })
map("n", "<leader>wr", "<c-w>r", { desc = "Swap window positions" })
map("n", "<leader>wK", "<c-w>t<c-w>K", { desc = "Switch horizontal split to vertical" })
map("n", "<leader>wH", "<c-w>t<c-w>H", { desc = "Switch vertical split to horizontal" })

local map_toggle = function(lhs, rhs, desc)
	map("n", [[\]] .. lhs, rhs, { desc = desc })
end

map_toggle("b", '<cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<cr>', "Toggle background")
map_toggle("c", "<cmd>setlocal cursorline! cursorline?<cr>", "Toggle cursorline")
map_toggle("l", "<cmd>setlocal list! list?<cr>", "Toggle list")
map_toggle("n", "<cmd>setlocal number! number?<cr>", "Toggle number")
map_toggle("s", "<cmd>setlocal spell! spell?<cr>", "Toggle spell")
map_toggle("w", "<cmd>setlocal wrap! wrap?<cr>", "Toggle wrap")
