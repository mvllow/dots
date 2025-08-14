#!/usr/bin/env bash

sudo dnf install -y git
sudo dnf install -y sway
sudo dnf install -y fish
sudo dnf install -y nodejs
sudo dnf install -y golang

# docker
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker # enable at startup (use start instead of enable to run once)
sudo usermod -aG docker $USER      # give docker sudo

# pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# neovim nightly
sudo dnf -y install ninja-build cmake gcc make unzip gettext curl
mkdir -p ~/build
cd ~/build
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cargo install --locked tree-sitter-cli

# lazygit
go install github.com/jesseduffield/lazygit@latest
