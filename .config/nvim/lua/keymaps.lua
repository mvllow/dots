local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc or '' })
end

vim.g.mapleader = ' '
map('n', '<space>', '<nop>')
map('n', '<esc>', ':noh<cr>')
map('i', 'jk', '<esc>')
map('n', 'j', 'gj')
map('n', 'k', 'gk')
map('v', '<', '<gv')
map('v', '>', '>gv')
map('n', '*', '*N')
map('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])
map('n', '#', '*Ncgn')
map('v', '#', [[y/\V<c-r>=escape(@",'/\')<cr><cr>Ncgn]])
map('n', '<leader>y', '"*y', 'yank selection to clipboard')

-- window
map('n', '<leader>wF', '<c-w>vgf', 'goto file (vsplit)')
map('n', '<leader>wf', '<c-w><c-f>', 'goto file (hsplit)')
map('n', '<leader>wh', '<c-w><c-h>', 'jump to split to the left')
map('n', '<leader>wj', '<c-w><c-j>', 'jump to split below')
map('n', '<leader>wk', '<c-w><c-k>', 'jump to split above')
map('n', '<leader>wl', '<c-w><c-l>', 'jump to split to the right')
map('n', '<leader>wo', ':only<cr>', 'close other windows')
map('n', '<leader>wq', ':quit<cr>', 'close window')
map('n', '<leader>ws', ':split<cr>', 'open split to the right')
map('n', '<leader>wv', ':vsplit<cr>', 'open split below')
map('n', '<leader>ww', '<c-w><c-w>', 'goto next window')

-- goto
map('n', 'gf', ':edit <cfile><cr>', 'goto file')
map('n', 'gh', '^', 'goto line start')
map('n', 'g.', '`.', 'goto last modification')
map('n', 'go', '<c-o>', 'goto previous position')
map('n', 'gO', '<c-i>', 'goto next position')
map('n', 'gp', ':bprevious<cr>', 'goto previous buffer')
map('n', 'gn', ':bnext<cr>', 'goto next buffer')

-- match
map('n', 'mm', '%', 'goto matching bracket')
-- map('n', 'ms', '', 'surround add')
-- map('n', 'mr', '', 'surround replace')
-- map('n', 'md', '', 'surround delete')
-- map('o', 'ma', 'va', 'select around object')
-- map('n', 'mi', '', 'select inside object')

-- diagnostic
map('n', '[d', vim.diagnostic.goto_prev, 'goto next diagnostic')
map('n', ']d', vim.diagnostic.goto_next, 'goto previous diagnostic')
map('n', 'gl', vim.diagnostic.open_float, 'show diagnostic message')

-- plugin
map('n', '<leader>/', ':Telescope live_grep<cr>', 'search text')
map('n', '<leader>b', ':Telescope buffers<cr>', 'search buffers')
map('n', '<leader>f', ':Telescope find_files<cr>', 'search files')
map('n', '<leader>e', ':NvimTreeFindFileToggle<cr>', 'explorer')
map('n', '<leader>h', ':TSHighlightCapturesUnderCursor<cr>', 'show highlight group under cursor')
map('n', '<leader>pc', ':PackerCompile<cr>', 'compile plugins')
map('n', '<leader>ps', ':PackerSync<cr>', 'sync plugins')
