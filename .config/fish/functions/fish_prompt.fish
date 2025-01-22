function fish_prompt
    set -l git_branch ""
    if git rev-parse --git-dir >/dev/null 2>&1
        set -l full_branch (git branch --show-current 2>/dev/null)
        if test -n "$full_branch"
            set -l branch_name (string split "/" "$full_branch")[-1]
            set git_branch " "(set_color yellow)"$branch_name"
        else
            # Handle detached HEAD state
            set -l commit_hash (git rev-parse --short HEAD 2>/dev/null)
            if test -n "$commit_hash"
                set git_branch " "(set_color red)"$commit_hash"
            end
        end
    end

    # [user main]: |
    string join "" -- \
        (set_color white --dim)"["(set_color normal) \
        (set_color white)(basename (pwd)) \
        "$git_branch" \
        (set_color white --dim)"]: "(set_color normal)
end
