#!/bin/env bash

set -e

mkdir -p ${HOME}/.local/bin
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O ${HOME}/.local/bin/oh-my-posh
chmod +x ${HOME}/.local/bin/oh-my-posh

ln -b -s ${HOME}/.shell/.digrc ${HOME}/.digrc
ln -b -s ${HOME}/.shell/.vimrc ${HOME}/.vimrc
ln -b -s ${HOME}/.shell/.vim ${HOME}/.vim
ln -b -s ${HOME}/.shell/.bashrc ${HOME}/.bashrc
