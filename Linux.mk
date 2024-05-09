.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

###############################################################################
# Default target
###############################################################################

install: bash posh gpg vim atuin mods code

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash: bash-configure

local_bin := .local/bin
bash_completion := .local/share/bash-completion

bash_dir := $(HOME)/$(local_bin) $(HOME)/$(bash_completion)

$(bash_dir):
	$(call header,Creating Bash directories)
	mkdir -p $(@)

bash-configure: $(bash_dir)
	$(call header,Configure Bash)
	ln -rfsv .profile $(HOME)/.profile
	ln -rfsv .bashrc $(HOME)/.bashrc
	ln -rfsv .bash_logout $(HOME)/.bash_logout
	ln -rfsv .digrc $(HOME)/.digrc
	ln -rfsv $(bash_completion)/completions $(HOME)/$(bash_completion)

bash-version:
	$(call header,Checking Bash status)
	bash --version

###############################################################################
# Oh-My-Posh: A prompt theme engine for any shell
###############################################################################

posh_bin := $(shell command -v oh-my-posh)

posh: posh-install posh-version

$(posh_bin):
	$(call header,Installing Oh-My-Posh)
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $(HOME)/$(local_bin)

posh-install: $(posh_bin)

posh-upgrade:
	$(call header,Installing Oh-My-Posh)
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $(HOME)/$(local_bin)

posh-version:
	$(call header,Oh-My-Posh version)
	echo $(posh_bin)
	oh-my-posh version

###############################################################################
# vim: Vi IMproved
###############################################################################

vim_bin := $(shell command -v vim)

vim: vim-install vim-configure

$(vim_bin):
	$(call header,Installing Vim)
	sudo apt install vim

vim-install: $(vim_bin)

vim-configure:
	$(call header,Configure Vim)
	ln -rfsv .vimrc $(HOME)/.vimrc
	ln -rfsv .vim $(HOME)

vim-uninstall:
	$(call header,Uninstalling Vim)
	sudo apt remove vim
	rm -rf $(HOME)/.vim $(HOME)/.vimrc

vim-version:
	$(call header,Checking Vim status)
	vim --version

###############################################################################
# GPG: GNU Privacy Guard
###############################################################################

gpg_bin := $(shell command -v gpg)
gpg_config := .gnupg/gpg.conf .gnupg/scdaemon.conf

gpg: gpg-install gpg-configure gpg-version

$(gpg_dir):
	$(call header,Creating GPG directories)
	mkdir -p $(@)
	chmod 700 $(@)

$(gpg_bin):
	$(call header,Installing GPG)
	sudo apt install gnupg

gpg-install: $(gpg_bin)

gpg-configure: $(gpg_dir)
	$(call header,Configure GPG)
	$(foreach file,$(gpg_config),ln -rfsv $(file) $(HOME)/$(file);)

gpg-version:
	$(call header,GPG version)
	gpg --version

###############################################################################
# atuin: A command-line tool for managing your dotfiles
###############################################################################

atuin_bin := $(shell command -v atuin)
atuin_config := .config/atuin/config.toml

atuin: atuin-install atuin-configure atuin-version

atuin-install: $(atuin_bin)

$(atuin_bin):
	$(call header,Installing Atuin)
	curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | bash

atuin-configure:
	$(call header,Configure Atuin)
	ln -rfsv $(atuin_config) $(HOME)/$(atuin_config)

atuin-version:
	$(call header,Atuin status)
	atuin status

###############################################################################
# k9s: A terminal-based UI to interact with your Kubernetes clusters
###############################################################################

###############################################################################
# Code: Visual Studio Code
###############################################################################
code_bin := $(shell command -v code)
code_dir := .config/Code/User
code_apt := /etc/apt/sources.list.d/vscode.list
code_gpg := /etc/apt/trusted.gpg.d/microsoft.gpg

code: code-install code-configure code-version

$(code_gpg):
	$(call header,Installing Code GPG key)
	curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o $@

$(code_apt):
	$(call header,Adding Code APT repository)
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee@ $@

$(code_bin): $(code_gpg) $(code_apt)
	$(call header,Installing Code)
	sudo apt update
	sudo apt install code

code-install: $(code_bin)

code-configure:
	$(call header,Configure Code)
	ln -rfsv $(code_dir)/settings.json $(HOME)/$(code_dir)/settings.json
	ln -rfsv $(code_dir)/keybindings.json $(HOME)/$(code_dir)/keybindings.json

code-version:
	$(call header,Code Version)
	code --version

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

mods_bin := $(shell command -v mods)
mods_config := .config/mods/mods.yml

mods: mods-install mods-configure mods-version

$(mods_bin): $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Installing Mods)
	sudo apt update
	sudo apt install mods

mods-install: $(mods_bin)

mods-configure:
	$(call header,Configuring Mods)
	ln -rfsv $(mods_config) $(HOME)/$(mods_config)

mods-uninstall:
	$(call header,Uninstalling Mods)
	sudo apt remove mods

mods-version:
	$(call header,Mods Version)
	echo $(mods_bin)
	mods --version

###############################################################################
# Glow: Render markdown on the CLI
# https://github.com/charmbracelet/glow
###############################################################################

glow: glow-install glow-version

glow-install: $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Installing Glow)
	sudo apt update && sudo apt install glow

glow-uninstall:
	$(call header,Uninstalling Glow)
	sudo apt remove glow

glow-version:
	$(call header,Glow Version)
	glow --version

###############################################################################
# Ollama: A CLI for the Ollama API
# https://ollama.com/download/linux
###############################################################################

ollama: ollama-install ollama-configure ollama-version

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

ollama-version:
	$(call header,Checking Ollama status)
	ollama --version
