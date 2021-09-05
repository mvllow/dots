vim.api.nvim_buf_set_option(0, 'commentstring', '# %s')

local tab_width = 2
vim.opt_local.tabstop = tab_width
vim.opt_local.softtabstop = tab_width
vim.opt_local.shiftwidth = tab_width
vim.opt_local.expandtab = true
