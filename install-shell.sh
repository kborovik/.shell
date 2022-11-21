#!/usr/bin/env bash

set -e

dirs=(
  ~/.local/bin/
  ~/.gnupg/
  ~/.vim/colors/
  ~/.config/helix/
)
mkdir -p "${dirs[@]}"

case $(uname) in
Linux)
  posh_binary="posh-linux-amd64"
  ;;
Darwin)
  posh_binary="posh-darwin-$(uname -m)"
  ;;
esac

wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$posh_binary" -O "$HOME/.local/bin/oh-my-posh" && chmod +x "$HOME/.local/bin/oh-my-posh"

files=(
  .bashrc
  .config/helix/config.toml
  .digrc
  .gnupg/gpg-agent.conf
  .gnupg/gpg.conf
  .gnupg/scdaemon.conf
  .profile
  .vim/colors/onehalfdark.vim
  .vimrc
)

for file in "${files[@]}"; do
  ln -b -s "$HOME/.shell/$file" "$HOME/$file"
done

