prompt() {
	# [user main](bash): |
	PS1="\[\e[2m\][\[\e[0m\]\[\e[37m\]\W\[\e[0m\]\$(parse_git_branch)\[\e[2m\]]($0):\[\e[0m\] "
}

parse_git_branch() {
	[ -d .git ] || return 1
	git symbolic-ref HEAD 2>/dev/null | sed 's#\(.*\)\/\([^\/]*\)$# \2#'
}

test -n "$PS1" && prompt

# -F to show indicators for directories (/), executables (*) and symlinks (@)
alias ls='ls -F --color=auto'
alias la='ls -aF --color=auto'
