function nvim -w nvim -d "Start Neovim with adaptive background"
    if test "$DARK_MODE" = on
        command nvim -c 'lcd %:p:h' -c 'set background=dark' $argv
    else
        command nvim -c 'lcd %:p:h' -c 'set background=light' $argv
    end
end
