# List files
function ls --wraps="ls -Ga"
    command ls -Ga $argv # -G for colour output; -a to show hidden files
end
