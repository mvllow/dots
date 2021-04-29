local set_keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

vim.g.bufferline = {
	animation = false,
	icons = false,
	icon_separator_active = '',
	icon_separator_inactive = '',
	no_name_title = '[ New buffer ]'
}

set_keymap('n', '}', ':BufferNext<cr>', opts)
set_keymap('n', '{', ':BufferPrevious<cr>', opts)
set_keymap('n', '<leader>bd', ':BufferClose<cr>', opts)
set_keymap('n', '<leader>bo', ':BufferCloseAllButCurrent<cr>', opts)
