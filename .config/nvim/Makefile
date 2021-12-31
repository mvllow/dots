SHELL := /bin/sh

install:
	@echo Installing neovim, language servers, and formatters
	brew install neovim --HEAD
	brew install lua-language-server shfmt stylua
	npm install --global @fsouza/prettierd typescript typescript-language-server vscode-langservers-extracted @tailwindcss/language-server svelte-language-server @volar/server

upgrade:
	@echo Upgrading neovim, language servers, and formatters
	brew upgrade neovim --fetch-head
	brew upgrade lua-language-server shfmt stylua
	npm update --global

uninstall:
	@echo Removing neovim, language servers, and formatters
	brew uninstall neovim lua-language-server shfmt stylua
	npm uninstall --global @fsouza/prettierd typescript typescript-language-server vscode-langservers-extracted @tailwindcss/language-server svelte-language-server @volar/server
