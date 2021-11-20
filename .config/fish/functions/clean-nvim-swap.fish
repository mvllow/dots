function clean-nvim-swap -d "remove neovim swap files"
    rm -rf "$HOME/.local/share/nvim/swap"
    echo "Removed nvim swap files"
end
