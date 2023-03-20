function fzf -w fzf
    set -l FZF_CUSTOM_OPTS "-i -m --header='$PWD' --layout=reverse"
    set -l FZF_NON_COLOR_OPTS

    for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
        if not string match -q -- "--color*" $arg
            set -a FZF_NON_COLOR_OPTS $arg
        end
    end

    set -q THEME; or set -gx THEME rose-pine

    if test $THEME = rose-pine
        set -gx FZF_DEFAULT_OPTS "$FZF_CUSTOM_OPTS $FZF_NON_COLOR_OPTS" \
            " --color=fg:#908caa,bg:#191724" \
            " --color=fg+:#908caa,bg+:#26233a" \
            " --color=bg+:#26233a,bg:#191724,spinner:#ebbcba,hl:#ebbcba" \
            " --color=fg:#908caa,header:#31748f,info:#9ccfd8,pointer:#ebbcba" \
            " --color=marker:#f6c177,fg+:#e0def4,prompt:#908caa,hl+:#ebbcba" \
            " --color=border:#403d52,gutter:#191724"
    else if test $THEME = rose-pine-moon
    else if test $THEME = rose-pine-dawn
    end

    command fzf $argv
end
