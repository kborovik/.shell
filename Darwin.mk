.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

###############################################################################
# Default target
###############################################################################

install: bash posh mods

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash_bin := /opt/homebrew/bin/bash
bash_config := .bashrc .bash_logout .profile .digrc
bash_completion := .local/share/bash-completion

bash: bash-install bash-configure

$(bash_completion):
	$(call header,Creating Bash directories)
	mkdir -p $(@)

$(bash-bin):
	$(call header,Installing Bash)
	brew install bash bash-completion@2

bash-configure: $(bash_completion)
	$(call header,Configure Bash)
	$(foreach file,$(bash_config),ln -fsv $(PWD)/$(file) $(HOME)/$(file);)
	ln -fsv $(PWD)/$(bash_completion)/completions $(HOME)/$(bash_completion)

bash-status:
	$(call header,Checking Bash status)
	bash --version

###############################################################################
# Oh-My-Posh: A prompt theme engine for any shell
###############################################################################

posh: posh-install

posh-install:
	$(call header,Installing Oh-My-Posh)
	brew install oh-my-posh

posh-uninstall:
	$(call header,Uninstalling Oh-My-Posh)
	brew rm oh-my-posh

posh-status:
	$(call header,Checking Oh-My-Posh status)
	oh-my-posh --version

###############################################################################
# vim: Vi IMproved
###############################################################################

vim: vim-install vim-configure

vim-install:
	$(call header,Installing Vim)
	brew install vim

vim-configure:
	$(call header,Configure Vim)
	ln -fsv .vimrc $(HOME)/.vimrc
	ln -fsv .vim $(HOME)

vim-uninstall:
	$(call header,Uninstalling Vim)
	brew rm vim
	rm -rf $(HOME)/.vim $(HOME)/.vimrc

vim-status:	
	$(call header,Checking Vim status)
	vim --version

###############################################################################
# GPG: GNU Privacy Guard
###############################################################################

gpg_bin := $(shell command -v gpg)
gpg_config := .gnupg/gpg.conf .gnupg/scdaemon.conf

opensc_bin := /Library/OpenSC/bin/openpgp-tool

gpg: gpg-install gpg-configure gpg-version

$(gpg_dir):
	$(call header,Creating GPG directories)
	mkdir -p $(@)
	chmod 700 $(@)

$(opensc_bin):
	$(call header,Installing OpenSC)
	brew install --cask opensc

$(gpg_bin):
	$(call header,Installing GPG)
	brew install gnupg

gpg-install: $(gpg_bin) $(opensc_bin)

gpg-configure: $(gpg_dir)
	$(call header,Configure GPG)
	$(foreach file,$(gpg_config),ln -fsv $(PWD)/$(file) $(HOME)/$(file);)

gpg-version:
	$(call header,GPG version)
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
# Mods: AI for the command line, built for pipelines.
# https://github.com/charmbracelet/mods
###############################################################################

mods_dir := "$(HOME)/Library/Application Support/mods"
mods_config := "$(HOME)/Library/Application Support/mods/mods.yml"

mods: mods-install mods-configure mods-status

mods-dirs:
	$(call header,Creating Mods directories)
	mkdir -p $(mods_dir)

mods-install: $(mods-dirs)
	$(call header,Installing Mods) 
	brew install mods

mods-configure:
	$(call header,Configure Mods)
	ln -fsv $(PWD)/.config/mods/mods.yml $(mods_config)

mods-uninstall:
	$(call header,Uninstalling Mods)
	brew rm mods
	rm -rf $(mods_dir)

mods-status:
	$(call header,Checking Mods status)
	mods --version

###############################################################################
# Ollama: A CLI for the Ollama API
# https://ollama.com/download/linux
###############################################################################

ollama: ollama-install

ollama-install:
	$(call header,Downloading Ollama installation to $(HOME)/Downloads/)
	curl -fsSl https://ollama.com/download/Ollama-darwin.zip -o $(HOME)/Downloads/Ollama-darwin.zip

ollama-configure:
	$(call header,Configure Ollama)
	ollama pull llama3
	ollama pull llama3:8b-instruct-q8_0

ollama-uninstall:
	$(call header,Uninstalling Ollama)

ollama-status:
	$(call header,Checking Ollama status)
	ollama --version
