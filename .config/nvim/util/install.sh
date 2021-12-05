#!/usr/bin/env bash

install_lua_ls() {
	mkdir -p "$HOME/.local/share" && cd "$HOME/.local/share"
	git clone --depth=1 https://github.com/sumneko/lua-language-server

	cd lua-language-server
	git submodule update --init --recursive

	cd 3rd/luamake
	compile/install.sh

	cd ../../
	./3rd/luamake/luamake rebuild
}

if [ ! -d "$HOME/.local/share/lua-language-server" ]; then
	install_lua_ls
fi

if which stylua &>/dev/null; then
	brew upgrade stylua
else
	brew install stylua
fi

if which nvim &>/dev/null; then
	brew upgrade neovim --fetch-head
else
	brew install neovim --HEAD
fi

npm install -g @fsouza/prettierd@latest typescript@latest typescript-language-server@latest vscode-langservers-extracted@latest svelte-language-server@latest

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
