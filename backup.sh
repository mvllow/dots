workspace=~/dev/dots

mkdir -p $workspace

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