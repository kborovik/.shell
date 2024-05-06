.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

###############################################################################
# Default target
###############################################################################

help: settings
	$(call header,Help)
	$(call help,make install,Install packages)
	$(call help,make configure,Configure packages)

install: posh mods gpg

configure: bash-configure vim-configure gpg-configure mods-configure

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash: bash-configure

bash_completion := $(HOME)/.local/share/bash-completion
local_bin := $(HOME)/.local/bin

bash_dirs := $(bash_completion) $(local_bin)

$(bash_dirs):
	$(call header,Creating Bash directories)
	mkdir -p $(@)

bash-configure: $(bash_dirs)
	$(call header,Configure Bash)
	ln -rfsv .bash_logout $(HOME)/.bash_logout
	ln -rfsv .bashrc $(HOME)/.bashrc
	ln -rfsv .digrc $(HOME)/.digrc
	ln -rfsv .profile $(HOME)/.profile
	ln -rfsv bash-completion/completions $(bash_completion)

bash-status:
	$(call header,Checking Bash status)
	bash --version

###############################################################################
# Oh-My-Posh: A prompt theme engine for any shell
###############################################################################

posh: posh-install posh-status

posh-install posh-upgrade:
	$(call header,Installing Oh-My-Posh)
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $(local_bin)

posh-status:
	$(call header,Checking Oh-My-Posh status)
	oh-my-posh --version

###############################################################################
# vim: Vi IMproved
###############################################################################

vim: vim-install vim-configure vim-status

vim-install:
	$(call header,Installing Vim)
	sudo apt install vim

vim-configure:
	$(call header,Configure Vim)
	ln -rfsv .vimrc $(HOME)/.vimrc
	ln -rfsv .vim $(HOME)

vim-uninstall:
	$(call header,Uninstalling Vim)
	sudo apt remove vim
	rm -rf $(HOME)/.vim $(HOME)/.vimrc

vim-status:	
	$(call header,Checking Vim status)
	vim --version

###############################################################################
# GPG: GNU Privacy Guard
###############################################################################

gpg_dir := $(HOME)/.gnupg

gpg: gpg-install gpg-configure gpg-status

$(gpg_dir):
	$(call header,Creating GPG directories)
	mkdir -p $(@)

gpg-install:
	$(call header,Installing GPG)
	sudo apt install gnupg

gpg-configure: $(gpg_dir)
	$(call header,Configure GPG)
	ln -rfsv .gnupg/gpg-agent.conf $(gpg_dir)/gpg-agent.conf
	ln -rfsv .gnupg/gpg.conf $(gpg_dir)/gpg.conf
	ln -rfsv .gnupg/scdaemon.conf $(gpg_dir)/scdaemon.conf

gpg-status:
	$(call header,Checking GPG status)
	gpg --version

###############################################################################
# atuin: A command-line tool for managing your dotfiles
###############################################################################

###############################################################################
# k9s: A terminal-based UI to interact with your Kubernetes clusters
###############################################################################

###############################################################################
# Code: Visual Studio Code
###############################################################################

###############################################################################
# TUI Library and Apps
# https://github.com/charmbracelet
###############################################################################

charm_gpg_key := /etc/apt/trusted.gpg.d/charm.gpg
charm_apt_repo := /etc/apt/sources.list.d/charm.list

$(charm_gpg_key):
	$(call header,Installing Charm GPG key)
	curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o $@

$(charm_apt_repo):
	$(call header,Adding Charm APT repository)
	echo "deb [signed-by=$(charm_gpg_key)] https://repo.charm.sh/apt/ * *" | sudo tee $@

###############################################################################
# Mods: AI for the command line, built for pipelines.
# https://github.com/charmbracelet/mods
###############################################################################

mods_config := "$(HOME)/.config/mods/mods.yml"

mods: mods-install mods-configure mods-status

mods-install: $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Installing Mods)
	sudo apt update && sudo apt install mods

mods-configure:
	$(call header,Configuring Mods)
	ln -rfsv mods.yml $(mods_config)

mods-uninstall:
	$(call header,Uninstalling Mods)
	sudo apt remove mods

mods-status:
	$(call header,Mods Version)
	mods --version

###############################################################################
# Glow: Render markdown on the CLI
# https://github.com/charmbracelet/glow
###############################################################################

glow: glow-install glow-status

glow-install: $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Installing Glow)
	sudo apt update && sudo apt install glow

glow-uninstall:
	$(call header,Uninstalling Glow)
	sudo apt remove glow

glow-status:
	$(call header,Glow Version)
	glow --version

###############################################################################
# Ollama: A CLI for the Ollama API
# https://ollama.com/download/linux
###############################################################################

ollama: ollama-install ollama-configure ollama-status

ollama-install:
	$(call header,Installing Ollama)
	curl -fsSL https://ollama.com/download/linux | sudo bash

ollama-configure:
	$(call header,Configure Ollama)
	ollama pull llama3

ollama-uninstall:
	$(call header,Uninstalling Ollama)
	sudo systemctl stop ollama
	sudo systemctl disable ollama
	sudo rm /etc/systemd/system/ollama.service
	sudo rm $$(which ollama)
	sudo userdel ollama
	sudo groupdel ollama

ollama-status:
	$(call header,Checking Ollama status)
	ollama --version
