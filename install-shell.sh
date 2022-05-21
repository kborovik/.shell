#!/bin/env bash

set -x

git clone git@github.com:kborovik/.shell.git

ln -b -s ${HOME}/.shell/.digrc ${HOME}/.digrc
ln -b -s ${HOME}/.shell/.vimrc ${HOME}/.vimrc
ln -b -s ${HOME}/.shell/.vim ${HOME}/.vim
ln -b -s ${HOME}/.shell/.bashrc ${HOME}/.bashrc
