prompt() {
	PS1="\e[37m\W\e[33m\$(parse_git_branch)\e[0m $ "
}

parse_git_branch() {
	[ -d .git ] || return 1
	git symbolic-ref HEAD 2>/dev/null | sed 's#\(.*\)\/\([^\/]*\)$# \2#'
}

test -n "$PS1" && prompt

# -F to show indicators for directories (/), executables (*) and symlinks (@)
alias ls='ls -F --color=auto'
