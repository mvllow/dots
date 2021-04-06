local utils = require('utils')

-- Install packer.nvim if not already
local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command(
        '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[packadd packer.nvim]]
-- Compile plugins when modified
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

require('plugins')

vim.g['prettier#autoformat'] = 1
vim.g['prettier#autoformat_require_pragma'] = 0

vim.g.mapleader = ' '

vim.cmd('syntax off')
utils.opt('b', 'shiftwidth', 4)
utils.opt('b', 'tabstop', 4)
utils.opt('o', 'hidden', true)
utils.opt('o', 'laststatus', 0)
utils.opt('o', 'splitbelow', true)
utils.opt('o', 'splitright', true)

utils.map('i', 'jk', '<esc>')

-- move through wrapped lines
utils.map('n', 'j', 'gj')
utils.map('n', 'k', 'gk')

-- plugin maps
utils.map('n', '<leader>cd', '<cmd>lcd %:p:h<cr>')
utils.map('n', '<leader>f',
          '<cmd>Telescope find_files find_command=rg,--ignore,--files<cr>')
utils.map('n', '<leader>z', '<cmd>Goyo<cr>')
