SHELL := /bin/bash

install:
	brew install node stylua
	brew install neovim --HEAD
	npm install --global prettier
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

update:
	brew update
	brew upgrade node stylua
	brew upgrade neovim --fetch-head
	npm update --global prettier
	rustup update
