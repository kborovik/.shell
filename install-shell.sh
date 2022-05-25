#!/bin/env bash

set -e

mkdir -p "${HOME}/.local/bin/" "${HOME}/.gnupg/" "${HOME}/.vim"

wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64" -O "${HOME}/.local/bin/oh-my-posh" && chmod +x "${HOME}/.local/bin/oh-my-posh"

ln -b -s "${HOME}/.shell/.bashrc" "${HOME}/.bashrc"
ln -b -s "${HOME}/.shell/.digrc" "${HOME}/.digrc"
ln -b -s "${HOME}/.shell/.gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
ln -b -s "${HOME}/.shell/.gnupg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ln -b -s "${HOME}/.shell/.gnupg/scdaemon.conf" "${HOME}/.gnupg/scdaemon.conf"
ln -b -s "${HOME}/.shell/.vim" "${HOME}/.vim"
ln -b -s "${HOME}/.shell/.vimrc" "${HOME}/.vimrc"
