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

install: bash gpg vim posh atuin mods

configure: bash-configure gpg-configure vim-configure atuin-configure mods-configure

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash: bash-configure

local_bin := .local/bin
bash_completion := .local/share/bash-completion

bash_dirs := $(HOME)/$(local_bin) $(HOME)/$(bash_completion)

$(bash_dirs):
	$(call header,Creating Bash directories)
	mkdir -p $(@)

bash-configure: $(bash_dirs)
	$(call header,Configure Bash)
	ln -rfsv .profile $(HOME)/.profile
	ln -rfsv .bashrc $(HOME)/.bashrc
	ln -rfsv .bash_logout $(HOME)/.bash_logout
	ln -rfsv .digrc $(HOME)/.digrc
	ln -rfsv $(bash_completion)/completions $(HOME)/$(bash_completion)

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

gpg_config := .gnupg/gpg.conf

gpg: gpg-install gpg-configure gpg-status

$(gpg_dir):
	$(call header,Creating GPG directories)
	mkdir -p $(@)
	chmod 700 $(@)

gpg-install:
	$(call header,Installing GPG)
	sudo apt install gnupg

gpg-configure: $(gpg_dir)
	$(call header,Configure GPG)
	ln -rfsv $(gpg_config) $(HOME)/$(gpg_config)

gpg-status:
	$(call header,Checking GPG status)
	gpg --version

###############################################################################
# atuin: A command-line tool for managing your dotfiles
###############################################################################

atuin_config := .config/atuin/config.toml

atuin: atuin-install atuin-configure atuin-status

atuin-install:
	$(call header,Installing Atuin)
	curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | bash

atuin-configure:
	$(call header,Configure Atuin)
	ln -rfsv $(atuin_config) $(HOME)/$(atuin_config)

atuin-status:
	$(call header,Checking Atuin status)
	atuin status

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

mods_config := .config/mods/mods.yml

mods: mods-install mods-configure mods-status

mods-install: $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Installing Mods)
	sudo apt update && sudo apt install mods

mods-configure:
	$(call header,Configuring Mods)
	ln -rfsv $(mods_config) $(HOME)/$(mods_config)

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
