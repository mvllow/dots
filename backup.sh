workspace=~/dev/dots

mkdir -p $workspace

rm -rf $workspace/brewfile
brew bundle dump --file=$workspace/brewfile

cp -r ~/.vimrc $workspace/.vimrc
cp -r ~/.zshrc $workspace/.zshrc
cp -r ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json $workspace/vscode/settings-insiders.json

code-insiders --list-extensions > $workspace/vscode/extensions.txt