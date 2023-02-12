# Use fish_key_reader to get escape sequences
function fish_user_key_bindings
    # Toggle theme via <super+l>
    bind \e\[108\;9u set_theme
end
