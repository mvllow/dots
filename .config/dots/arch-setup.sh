#!/usr/bin/env bash

# set ssh permissions
chmod 600 ~/.ssh/id_ed25509

# install yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo pacman -S fd
sudo pacman -S fish
sudo pacman -S fuzzel # app launcher
sudo pacman -S fzf
sudo pacman -S lazygit
sudo pacman -S lf   # file manager
sudo pacman -S mako # notification daemon
sudo pacman -S niri # window manager
sudo pacman -S nodejs
sudo pacman -S npm
sudo pacman -S ripgrep
sudo pacman -S ristretto       # image previewer
sudo pacman -S tree-sitter-cli # for neovim
sudo pacman -S wl-clipboard    # wayland clipboard

yay -S ghostty-git
yay -S neovim-git
yay -S tmux-git

# install pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# install and enable docker
sudo pacman -S docker
sudo systemctl enable docker.service # start after boot
sudo usermod -aG docker $USER        # same as sudo!

# refresh font cache (~/.local/share/fonts)
fc-cache -fv
