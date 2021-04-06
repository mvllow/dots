workspace=~/dev/dots

mkdir -p $workspace
cd $workspace

# workspace is clean
if [ -z "$(git status --porcelain)" ]; then 
  rm -rf $workspace/brewfile
  brew bundle dump --file=$workspace/brewfile

  # vim
  cp -r ~/.vimrc $workspace/.vimrc

  # neovim
  cp -a ~/.config/nvim/lua/. $workspace/nvim/lua/
  cp -r ~/.config/nvim/init.lua $workspace/nvim/

  # zsh
  cp -r ~/.zshrc $workspace/.zshrc

  # vscode
  cp -r ~/Library/Application\ Support/Code/User/settings.json $workspace/vscode/settings.json
  code --list-extensions > $workspace/vscode/extensions.txt

  git add .
  git commit -m "✨ sync with local ✨"

# uncommitted changes in workspace
else
    echo "\033[0;31m✕ Working directory has uncommited changes\033[0m"
    echo "\033[0;90m  Please commit changes in $workspace\033[0m\n"
fi
