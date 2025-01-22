function fish_prompt
    string join "" -- (prompt_pwd --dir-length=0) (set_color brblack; fish_git_prompt; set_color normal) "> "
end
