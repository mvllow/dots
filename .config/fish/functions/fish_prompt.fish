function fish_prompt
    set -g __fish_git_prompt_showdirtystate 1
    string join "" -- (prompt_pwd --dir-length=0) (set_color brblack; fish_git_prompt; set_color normal) "> "
end
