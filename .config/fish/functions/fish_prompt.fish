function fish_prompt
    set -g fish_prompt_pwd_dir_length 0
    printf '%s%s> ' (prompt_pwd) (set_color brblack; fish_git_prompt; set_color normal)
end
