# Open neovim with the file's location as the working directory
function nvim --wraps="nvim -c 'lcd %:p:h'"
    command nvim -c 'lcd %:p:h' $argv
end
