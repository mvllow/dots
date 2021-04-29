local set_keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- TODO: Why doesn't this work :(
-- require'telescope'.setup {
-- 	defaults = {
-- 		-- use ripgrep
-- 		-- show hidden, but not `.git/`
-- 		find_command = {'rg', '--files', '--hidden', '-g', '!node_modules', '-g', '!git'}
-- 	}
-- }

-- TODO: Why doesn't -g,!{.git,node_modules} work?
set_keymap('n', '<leader>f', ':Telescope find_files find_command=rg,--hidden,--files,-g,!.git,-g,!node_modules<cr>', opts)
set_keymap('n', '<leader>/', ':Telescope live_grep<cr>', opts)
