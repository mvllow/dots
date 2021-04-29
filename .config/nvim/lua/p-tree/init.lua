local set_keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_side = 'right'
vim.g.nvim_tree_ignore = {'.git'}

set_keymap('n', '<leader>e', ':NvimTreeToggle<cr>', opts)
