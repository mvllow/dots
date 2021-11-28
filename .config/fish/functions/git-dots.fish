function git-dots -a directory -d "find untracked dotfiles"
    if test -n "$directory"
        .git ls-files --other "$directory/*"
    else
        .git ls-files --other "$HOME/.config/*"
    end
end
