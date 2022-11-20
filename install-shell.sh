#!/usr/bin/env bash

set -e

mkdir -p "${HOME}/.local/bin/" "${HOME}/.gnupg/" "${HOME}/.vim/colors/"

wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-$(uname -o)-$(uname -m)" -O "${HOME}/.local/bin/oh-my-posh" && chmod +x "${HOME}/.local/bin/oh-my-posh"

ln -b -s "${HOME}/.shell/.bashrc" "${HOME}/.bashrc"
ln -b -s "${HOME}/.shell/.digrc" "${HOME}/.digrc"
ln -b -s "${HOME}/.shell/.gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
ln -b -s "${HOME}/.shell/.gnupg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ln -b -s "${HOME}/.shell/.gnupg/scdaemon.conf" "${HOME}/.gnupg/scdaemon.conf"
ln -b -s "${HOME}/.shell/.vim/colors/onehalfdark.vim" "${HOME}/.vim/colors/onehalfdark.vim"
ln -b -s "${HOME}/.shell/.vimrc" "${HOME}/.vimrc"
