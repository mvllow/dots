#!/usr/bin/env bash

brew uninstall neovim stylua
npm uninstall -g @fsouza/prettierd typescript typescript-language-server vscode-langservers-extracted @tailwindcss/language-server svelte-language-server

rm -rf "$HOME/.local/share/lua-language-server"
rm -rf "$HOME/.local/share/nvim"

echo "~/.config/nvim has not been removed"
