local function map(mode, lhs, rhs, opts)
	opts = opts or { silent = true }
	return vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = ' '
map('n', '<space>', '<nop>')
map('n', '<esc>', ':noh<cr>')
map('i', '<c-k>', vim.lsp.buf.signature_help)
map('i', 'jk', '<esc>')
map('n', 'j', 'gj')
map('n', 'k', 'gk')
map('v', '<', '<gv')
map('v', '>', '>gv')
map('n', '*', '*N')
map('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])
map('n', '#', '*Ncgn')
map('v', '#', [[y/\V<c-r>=escape(@",'/\')<cr><cr>Ncgn]])
map('n', '<leader>y', '"*y')

-- window
map('n', '<leader>ws', ':split<cr>')
map('n', '<leader>wv', ':vsplit<cr>')
map('n', '<leader>wf', '<c-w><c-f>')
map('n', '<leader>wF', '<c-w>vgf')
map('n', '<leader>wo', ':only<cr>')
map('n', '<leader>wq', ':quit<cr>')
map('n', '<leader>ww', '<c-w><c-w>')
map('n', '<leader>wh', '<c-w><c-h>')
map('n', '<leader>wj', '<c-w><c-j>')
map('n', '<leader>wk', '<c-w><c-k>')
map('n', '<leader>wl', '<c-w><c-l>')

-- lsp
map('n', 'K', vim.lsp.buf.hover)
map('n', '<leader>a', vim.lsp.buf.code_action)
map('n', '<leader>r', vim.lsp.buf.rename)

-- goto
map('n', 'gl', vim.diagnostic.open_float)
map('n', 'gf', ':edit <cfile><cr>')
map('n', 'gh', '^') -- goto line start
-- map('n', 'gl', 'g_') -- goto line end
-- map('n', 'ga', '') -- goto last accessed file
-- map('n', 'gm', '') -- goto last modified file
map('n', 'gd', vim.lsp.buf.definition)
map('n', 'gr', vim.lsp.buf.references)
map('n', 'gi', vim.lsp.buf.implementation)
map('n', 'g.', '`.') -- goto last modification
map('n', 'go', '<c-o>') -- goto previous position
map('n', 'gO', '<c-i>') -- goto next position
map('n', 'gp', ':bprevious<cr>')
map('n', 'gn', ':bnext<cr>')

-- match
-- map('n', 'mm', '') -- goto matching bracket
-- map('n', 'ms', '') -- surround add
-- map('n', 'mr', '') -- surround replace
-- map('n', 'md', '') -- surround delete
-- map('n', 'ma', '') -- select around object
-- map('n', 'mi', '') -- select inside object

map('n', '[d', vim.diagnostic.goto_prev) -- goto previous diagnostic
-- map('n', '[D', '') -- goto first diagnostic
map('n', ']d', vim.diagnostic.goto_next) -- goto next diagnostic
-- map('n', ']D', '') -- goto last diagnostic

-- plugins
map('n', '<leader>/', ':Telescope live_grep<cr>')
map('n', '<leader>f', ':Telescope find_files<cr>')
map('n', '<leader>b', ':Telescope buffers<cr>')
map('n', '<leader>e', ':NvimTreeFindFileToggle<cr>')
map('n', '<leader>pc', ':PackerCompile<cr>')
map('n', '<leader>ps', ':PackerSync<cr>')
map('n', '<leader>h', ':TSHighlightCapturesUnderCursor<cr>')

-- good default maps to remember
-- `{` and `}` jump to next/previous blank line
-- `g;` jump to previous change
-- `gv` repeat last visual selection
