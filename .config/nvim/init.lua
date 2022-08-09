--- init.lua
--- https://github.com/mvllow/lilvim

--- Combines all modules of lilvim.

vim.g.mapleader = ' '
vim.keymap.set('n', '<space>', '<nop>', { silent = true })

require('lil-ui')
require('lil-editing')
require('lil-search')
require('lil-lsp')
require('lil-completions')
require('lil-extras')
