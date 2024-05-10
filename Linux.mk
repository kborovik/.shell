###############################################################################
# Default target
###############################################################################

install: bash posh git gpg vim atuin mods code

###############################################################################
# General functions
###############################################################################

local_bin := $(HOME)/.local/bin

$(local_bin):
	$(call header,Local Bin directory)
	mkdir -p $(@)

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash_config := .bashrc .bash_logout .profile .digrc
bash_completion := .local/share/bash-completion

bash_dir := $(HOME)/$(bash_completion)

bash: bash-configure bash-version

$(bash_dir):
	$(call header,Bash - Create directories)
	mkdir -p $(@)

bash-configure: $(bash_dir)
	$(call header,Bash - Configure)
	$(foreach file,$(bash_config),ln -rfsv $(file) $(HOME)/$(file);)
	ln -rfsv $(bash_completion)/completions $(HOME)/$(bash_completion)

bash-version:
	$(call header,Bash - Version)
	bash --version

###############################################################################
# Git: Distributed version control system
###############################################################################

git_bin := /usr/bin/git

git: git-install git-configure git-version

$(git_bin):
	$(call header,Git - Install)
	sudo apt update
	sudo apt install git

git-install: $(git_bin)

git-configure:
	$(call header,Git - Configure)
	ln -rfsv .gitconfig $(HOME)/.gitconfig

###############################################################################
# Oh-My-Posh: A prompt theme engine for any shell
###############################################################################

posh_bin := /home/kb/.local/bin/oh-my-posh

posh: $(local_bin) posh-install posh-version

$(posh_bin):
	$(call header,POSH - Install)
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $(local_bin)

posh-install: $(posh_bin)

posh-upgrade:
	$(call header,POSH - Upgrade)
	oh-my-posh version
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $(local_bin)
	oh-my-posh version

posh-version:
	$(call header,POSH - Version)
	oh-my-posh version

###############################################################################
# vim: Vi IMproved
###############################################################################

vim_bin := /usr/bin/vim

vim: vim-install vim-configure

$(vim_bin):
	$(call header,Vim - Install)
	sudo apt install vim

vim-install: $(vim_bin)

vim-configure:
	$(call header,Vim - Configure)
	ln -rfsv .vimrc $(HOME)/.vimrc
	ln -rfsv .vim $(HOME)

vim-uninstall:
	$(call header,Vim - Uninstall)
	sudo apt remove vim
	rm -rf $(HOME)/.vim $(HOME)/.vimrc

vim-version:
	$(call header,Vim - Version)
	vim --version

###############################################################################
# GPG: GNU Privacy Guard
###############################################################################

gpg_bin := /usr/bin/gpg
gpg_dir := $(HOME)/.gnupg
gpg_config := .gnupg/gpg.conf .gnupg/scdaemon.conf

gpg: gpg-install gpg-configure gpg-version

$(gpg_dir):
	$(call header,GPG - Directories)
	mkdir -p $(@)
	chmod 700 $(@)

$(gpg_bin):
	$(call header,GPG - Install)
	sudo apt install gnupg

gpg-install: $(gpg_bin)

gpg-configure: $(gpg_dir)
	$(call header,GPG - Configure)
	$(foreach file,$(gpg_config),ln -rfsv $(file) $(HOME)/$(file);)

gpg-version:
	$(call header,GPG - Version)
	gpg --version

###############################################################################
# k9s: A terminal-based UI to interact with your Kubernetes clusters
###############################################################################

###############################################################################
# Code: Visual Studio Code
###############################################################################
code_bin := /usr/bin/code
code_dir := .config/Code/User
code_gpg := /etc/apt/trusted.gpg.d/microsoft.gpg
code_apt := /etc/apt/sources.list.d/vscode.list

code: code-install code-configure code-version

$(code_dir):
	$(call header,Code - Directories)
	mkdir -p $(@)

$(code_gpg):
	$(call header,Code - Microsoft GPG Public Key)
	curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o $@

$(code_apt):
	$(call header,Code - APT Repository)
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee@ $@

$(code_bin): $(code_gpg) $(code_apt)
	$(call header,Code - Install)
	sudo apt update
	sudo apt install code

code-install: $(code_bin)

code-configure:
	$(call header,Code - Configure)
	ln -rfsv $(code_dir)/settings.json $(HOME)/$(code_dir)/settings.json
	ln -rfsv $(code_dir)/keybindings.json $(HOME)/$(code_dir)/keybindings.json

code-version:
	$(call header,Code - Version)
	code --version

###############################################################################
# TUI Library and Apps
# https://github.com/charmbracelet
###############################################################################

charm_gpg_key := /etc/apt/trusted.gpg.d/charm.gpg
charm_apt_repo := /etc/apt/sources.list.d/charm.list

$(charm_gpg_key):
	$(call header,Charm - GPG Public Key)
	curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o $@

$(charm_apt_repo):
	$(call header,Charm - APT repository)
	echo "deb [signed-by=$(charm_gpg_key)] https://repo.charm.sh/apt/ * *" | sudo tee $@

###############################################################################
# Mods: AI for the command line, built for pipelines.
# https://github.com/charmbracelet/mods
###############################################################################

mods_bin := /usr/bin/mods
mods_config := .config/mods/mods.yml

mods: mods-install mods-configure mods-version

$(mods_bin): $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Mods - Install)
	sudo apt update
	sudo apt install mods

mods-install: $(mods_bin)

mods-configure:
	$(call header,Mods - Configure)
	ln -rfsv $(mods_config) $(HOME)/$(mods_config)

mods-uninstall:
	$(call header,Mods - Uninstall)
	sudo apt remove mods

mods-version:
	$(call header,Mods - Version)
	mods --version

###############################################################################
# Glow: Render markdown on the CLI
# https://github.com/charmbracelet/glow
###############################################################################

glow_bin := /usr/bin/glow

glow: glow-install glow-version

$(glow_bin): $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Glow - Install)
	sudo apt update
	sudo apt install glow

glow-install: $(glow_bin)

glow-uninstall:
	$(call header,Glow - Uninstall)
	sudo apt remove glow

glow-version:
	$(call header,Glow - Version)
	glow --version

###############################################################################
# Ollama: A CLI for the Ollama API
# https://ollama.com/download/linux
###############################################################################

ollama_bin := /usr/local/bin/ollama

ollama: ollama-install ollama-configure ollama-version

$(ollama_bin):
	$(call header,Ollama - Install)
	curl -fsSL https://ollama.com/download/linux | sudo bash

ollama-install: $(ollama_bin)

ollama-configure:
	$(call header,Ollama - Configure)
	ollama pull llama3

ollama-uninstall:
	$(call header,Ollama - Uninstall)
	sudo systemctl stop ollama
	sudo systemctl disable ollama
	sudo rm /etc/systemd/system/ollama.service
	sudo rm $$(which ollama)
	sudo userdel ollama
	sudo groupdel ollama

ollama-version:
	$(call header,Ollama - Version)
	ollama --version
