# prompt
prompt='%~> '

# cd
alias ..='cd ..'
alias ...='cd ../..'

# list
alias l='ls -a'

# editors
alias n='nvim'
alias c='code-insiders .'

# git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias go='git checkout'
alias gu='git push'
alias gp='git pull'
alias gr='git pull --rebase'
alias gb='git branch'
alias gm='git merge'
alias gl='git log -n 10 --graph --decorate --oneline --no-merges'

# git status of <directory>
gsdir() {
  cd $1
  git status
  cd ..
}

# remove local branches if merged in <remote branch>
chop () {
  git branch --merged | egrep -v "(^\*|$1)" | xargs git branch -d
}

# clone <owner/repo> to ~/dev
clone() {
  cd ~/dev
  git clone git@github.com:$1.git
}

# upload <file> to 0x0.st
0x0() {
  curl -F "file=@$1" https://0x0.st | pbcopy
}

# shorten <url> via 0x0.st
shorten() {
  curl -F "shorten=$1" https://0x0.st | pbcopy
}

# create <folder> and navigate to it
md() {
  mkdir -p -- "$1"
  cd -P -- "$1"
}

# navigate to <folder> in ~/dev
dev() {
  cd "$HOME/dev/$1"
}

# search <directory> for <file>
# ignores node_modules and dot directories
fdir() {
  find "$1" -type d \( -name node_modules -o -path '*/\.*' \) -prune -false -o -name "*$2*"
}

# search current directory for <file>
f() {
  fdir . "$1"
}

# add brew to path
export PATH=/opt/homebrew/bin:$PATH
