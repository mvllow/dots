function fish_prompt
    set -g fish_prompt_pwd_dir_length 0
    printf '%s> ' (prompt_pwd)
end

function fish_right_prompt
    printf '%s' (fish_git_prompt)
end
