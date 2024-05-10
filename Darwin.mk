###############################################################################
# Default target
###############################################################################

install: bash posh git gpg git vim mods atuin gcloud terraform

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
	$(foreach file,$(bash_config),ln -fs $(PWD)/$(file) $(HOME)/$(file);)
	ln -fs $(PWD)/$(bash_completion)/completions $(HOME)/$(bash_completion)

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
	ln -fs $(PWD)/.gitconfig $(HOME)/.gitconfig

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
	ln -fs $(PWD)/.vimrc $(HOME)/.vimrc
	ln -fs $(PWD)/.vim $(HOME)

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
gpg_dir := $(HOME)/.gnupg
gpg_config := .gnupg/gpg.conf

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
	$(foreach file,$(gpg_config),ln -fs $(PWD)/$(file) $(HOME)/$(file);)

gpg-version:
	$(call header,GPG - Version)
	gpg --version

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

$(mods_bin):
	$(call header,Mods - Install) 
	brew install mods

mods-install: $(mods_bin)

mods-configure: $(mods_dir)
	$(call header,Mods - Configure)
	ln -fs $(PWD)/.config/mods/mods.yml $(mods_config)

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
	brew tap hashicorp/tap
	brew install hashicorp/tap/terraform

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
	$(call header,Ollama - Install)
	brew install --cask ollama

ollama-configure:
	$(call header,Ollama - Configure)
	ollama pull llama3

ollama-uninstall:
	$(call header,Ollama - Uninstall)

ollama-version:
	$(call header,Ollama version)
	ollama --version
