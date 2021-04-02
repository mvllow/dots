return require('packer').startup(function()
    use {'wbthomason/packer.nvim', opt = true}
    use {'junegunn/goyo.vim'}
    use {'prettier/vim-prettier'}
    use {'nvim-treesitter/nvim-treesitter'}
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    use {'neovim/nvim-lspconfig'}
    use {'nvim-lua/completion-nvim'}
end)
