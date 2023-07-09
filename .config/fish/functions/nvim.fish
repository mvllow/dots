function nvim -w "nvim -c 'lcd %:p:h'" -d "Open neovim with the file's location as the working directory"
    if [ "$TERM" = screen-256color -a "$THEME" = rose-pine-dawn ]
        set background " -c 'set background=light' "
        command nvim -c 'lcd %:p:h' -c 'set background=light' $argv
    else
        command nvim -c 'lcd %:p:h' $argv
    end
end
