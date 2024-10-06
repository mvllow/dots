# $ clone dots
#   > Cloned git@github.com:<user>/dots to ./dots
# $ clone mvllow/pinecone
#   > Cloned git@github.com:mvllow/pinecone to ./mvllow-pinecone
# $ clone rose-pine/neovim
#   > Cloned git@github.com:rose-pine/neovim to ./rose-pine-neovim
function clone -w "git clone" -a input -d "Clone remote repository"
    string match -rq '(?<user>.*)?\/(?<repo>.*)' -- $input

    if test -n "$repo"
        set source "$input"
        # Strip user name from repo name
        # @example mvllow/dots => dots
        # @example rose-pine/neovim => rose-pine-neovim
        # @example rose-pine/rose-pine-site => rose-pine-site
        if [ "$user" != "$repo" ]
            set output $(string replace "$user-$user-" "$user-" "$user-$repo")
        else
            set output "$repo"
        end
    else
        set source "$(git config --get user.name)/$input"
        set output "$input"
    end

    if test $argv[2]
        git clone git@github.com:$source.git $argv[2..]
        set clone_dir "$argv[2]"
    else
        git clone git@github.com:$source.git $output
        set clone_dir "$output"
    end

    set session_name (string replace -r '\W' '_' "$output")

    tmux new-session -ds "$session_name" -c "$PWD/$clone_dir"

    if test -n "$TMUX"
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    end
end
