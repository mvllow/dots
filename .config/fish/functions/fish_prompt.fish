function fish_prompt
    set_theme system

    printf '[%s%s]$ ' (fish_prompt_pwd_dir_length=0 prompt_pwd) (set_color brblack; fish_git_prompt; set_color normal)
end
