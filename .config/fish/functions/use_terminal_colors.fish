function use_terminal_colors
    # syntax highlighting variables
    # https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables
    set -U fish_color_normal normal
    set -U fish_color_command magenta
    set -U fish_color_keyword blue
    set -U fish_color_quote yellow
    set -U fish_color_redirection green
    set -U fish_color_end brblack
    set -U fish_color_error red
    set -U fish_color_param cyan
    set -U fish_color_comment brblack
    set -U fish_color_selection --reverse
    set -U fish_color_operator normal
    set -U fish_color_escape green
    set -U fish_color_autosuggestion brblack
    set -U fish_color_cwd cyan
    set -U fish_color_user yellow
    set -U fish_color_host blue
    set -U fish_color_host_remote magenta
    set -U fish_color_cancel normal
    set -U fish_color_search_match --background=black
    set -U fish_color_valid_path

    # pager color variables
    # https://fishshell.com/docs/current/interactive.html#pager-color-variables
    set -U fish_pager_color_progress cyan
    set -U fish_pager_color_background
    set -U fish_pager_color_prefix blue
    set -U fish_pager_color_completion brblack
    set -U fish_pager_color_description brblack
    set -U fish_pager_color_secondary_background
    set -U fish_pager_color_secondary_prefix
    set -U fish_pager_color_secondary_completion
    set -U fish_pager_color_secondary_description
    set -U fish_pager_color_selected_background
    set -U fish_pager_color_selected_prefix blue
    set -U fish_pager_color_selected_completion white
    set -U fish_pager_color_selected_description white
end
