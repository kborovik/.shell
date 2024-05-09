.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

###############################################################################
# Default target
###############################################################################

install: bash posh git gpg vim mods

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash_bin := /opt/homebrew/bin/bash
bash_config := .bashrc .bash_logout .profile .digrc
bash_completion := .local/share/bash-completion

bash: bash-install bash-configure bash-version

$(bash_completion):
	$(call header,Bash - Create directories)
	mkdir -p $(@)

$(bash-bin):
	$(call header,Bash - Install)
	brew install bash bash-completion@2

bash-install: $(bash_bin)

bash-configure: $(bash_completion)
	$(call header,Bash - Configure)
	$(foreach file,$(bash_config),ln -fsv $(PWD)/$(file) $(HOME)/$(file);)
	ln -fsv $(PWD)/$(bash_completion)/completions $(HOME)/$(bash_completion)

bash-version:
	$(call header,Bash - Version)
	bash --version

###############################################################################
# Git: Distributed version control system
###############################################################################

git_bin := /opt/homebrew/bin/git

git: git-install git-configure git-version

$(git_bin):
	$(call header,Git - Install)
	brew install git

git-install: $(git_bin)

git-configure:
	$(call header,Git - Configure)
	ln -fsv $(PWD)/.gitconfig $(HOME)/.gitconfig

git-version:
	$(call header,Git - Version)
	git --version

###############################################################################
# Oh-My-Posh: A prompt theme engine for any shell
###############################################################################

posh: posh-install posh-version

posh-install:
	$(call header,POSH - Install)
	brew install oh-my-posh

posh-uninstall:
	$(call header,POSH - Uninstall)
	brew rm oh-my-posh

posh-version:
	$(call header, POSH - Version)
	oh-my-posh --version

###############################################################################
# vim: Vi IMproved
###############################################################################

vim_bin := /opt/homebrew/bin/vim
vim: vim-install vim-configure

$(vim_bin):
	$(call header,Vim - Install)
	brew install vim

vim-install: $(vim_bin)

vim-configure:
	$(call header,Vim - Configure)
	ln -fsv $(PWD)/.vimrc $(HOME)/.vimrc
	ln -fsv $(PWD)/.vim $(HOME)

vim-uninstall:
	$(call header,Vim - Uninstall)
	brew rm vim
	rm -rf $(HOME)/.vim $(HOME)/.vimrc

vim-version:	
	$(call header,Vim - Version)
	vim --version

###############################################################################
# GPG: GNU Privacy Guard
###############################################################################

gpg_bin := /opt/homebrew/bin/gpg
gpg_config := .gnupg/gpg.conf .gnupg/scdaemon.conf

opensc_bin := /Library/OpenSC/bin/openpgp-tool

gpg: gpg-install gpg-configure gpg-version

$(gpg_dir):
	$(call header,GPG - Create directories)
	mkdir -p $(@)
	chmod 700 $(@)

$(opensc_bin):
	$(call header,OpenSC - Install)
	brew install --cask opensc

$(gpg_bin):
	$(call header,GPG - Install)
	brew install gnupg

gpg-install: $(gpg_bin) $(opensc_bin)

gpg-configure: $(gpg_dir)
	$(call header,GPG - Configure)
	$(foreach file,$(gpg_config),ln -fsv $(PWD)/$(file) $(HOME)/$(file);)

gpg-version:
	$(call header,GPG - Version)
	gpg --version

###############################################################################
# atuin: A command-line tool for managing your dotfiles
###############################################################################

atuin_bin := /opt/homebrew/bin/atuin
atuin_config := .config/atuin/config.toml

atuin: atuin-install atuin-configure atuin-version

atuin-install: $(atuin_bin)

$(atuin_bin):
	$(call header,Installing Atuin)
	curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | bash

atuin-configure:
	$(call header,Configure Atuin)
	ln -fsv $(PWD)/$(atuin_config) $(HOME)/$(atuin_config)

atuin-version:
	$(call header,Atuin status)
	atuin status

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

mods_bin := /opt/homebrew/bin/mods
mods_dir := $(HOME)/Library/Application\ Support/mods
mods_config := $(HOME)/Library/Application\ Support/mods/mods.yml

mods: mods-install mods-configure mods-version

$(mods_dir):
	$(call header,Mods - Create directories)
	mkdir -p $(@)

$(mods_bin): $(mods_dir)
	$(call header,Mods - Install) 
	brew install mods

mods-install: $(mods_bin)

mods-configure:
	$(call header,Mods - Configure)
	ln -fsv $(PWD)/.config/mods/mods.yml $(mods_config)

mods-uninstall:
	$(call header,Mods - Uninstall)
	brew rm mods
	rm -rf $(mods_dir)

mods-version:
	$(call header,Mods - Version)
	mods --version

###############################################################################
# Google Cloud SDK
###############################################################################

gcloud_bin := /opt/homebrew/bin/gcloud

gcloud: gcloud-install gcloud-version

$(gcloud_bin):
	$(call header,Google Cloud SDK - Install)
	brew install --cask google-cloud-sdk

gcloud-install: $(gcloud_bin)

# gcloud-configure:
# $(call header,Google Cloud SDK - Configure)
# gcloud init

gcloud-version:
	$(call header,Google Cloud SDK - Version)
	gcloud --version

###############################################################################
# Terraform: Infrastructure as Code
###############################################################################

terraform_bin := /opt/homebrew/bin/terraform

terraform: terraform-install terraform-version

$(terraform_bin):
	$(call header,Terraform - Install)
	brew install terraform

terraform-install: $(terraform_bin)

terraform-version:
	$(call header,Terraform - Version)
	terraform --version

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

ollama-version:
	$(call header,Ollama version)
	ollama --version
