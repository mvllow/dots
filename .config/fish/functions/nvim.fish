function nvim -w "nvim -c 'lcd %:p:h'" -d "Open neovim with the file's location as the working directory"
    command nvim -c 'lcd %:p:h' $argv
end
