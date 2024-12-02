function nvim -w nvim -d "Start Neovim with adaptive background"
    set mode light
    defaults read -g AppleInterfaceStyle >/dev/null 2>&1

    if test $status -eq 0
        set mode dark
    end

    command nvim -c 'lcd %:p:h' -c "set background=$mode" $argv
end
