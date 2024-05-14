###############################################################################
# Linux specific settings
###############################################################################

lsb_release := $(shell lsb_release -cs)

###############################################################################
# Default target
###############################################################################

install: apt-update bash posh git gpg vim atuin mods code gcloud terraform

###############################################################################
# General functions
###############################################################################

local_bin := $(HOME)/.local/bin

$(local_bin):
	$(call header,Local Bin directory)
	mkdir -p $(@)

apt-update:
	$(call header,APT - Update)
	sudo apt update

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
	$(foreach file,$(bash_config),ln -rfs $(file) $(HOME)/$(file);)
	ln -rfs $(bash_completion)/completions $(HOME)/$(bash_completion)

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
	sudo apt install git

git-install: $(git_bin)

git-configure:
	$(call header,Git - Configure)
	ln -rfs .gitconfig $(HOME)/.gitconfig

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
	ln -rfs .vimrc $(HOME)/.vimrc
	ln -rfs .vim $(HOME)

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

scdaemon_bin := /usr/lib/gnupg/scdaemon
gpg_bin := /usr/bin/gpg
gpg_dir := $(HOME)/.gnupg
gpg_config := .gnupg/gpg.conf .gnupg/scdaemon.conf .gnupg/gpg-agent.conf

gpg: gpg-install gpg-configure gpg-version

$(scdaemon_bin):
	$(call header,GPG - Install scdaemon)
	sudo apt install scdaemon

$(gpg_dir):
	$(call header,GPG - Directories)
	mkdir -p $(@)
	chmod 700 $(@)

$(gpg_bin):
	$(call header,GPG - Install)
	sudo apt install gnupg

gpg-install: $(gpg_bin) $(scdaemon_bin)

gpg-configure: $(gpg_dir)
	$(call header,GPG - Configure)
	$(foreach file,$(gpg_config),ln -rfs $(file) $(HOME)/$(file);)

gpg-version:
	$(call header,GPG - Version)
	gpg --version

###############################################################################
# gcloud: Google Cloud SDK
###############################################################################

gcloud_bin := /usr/bin/gcloud

gcloud_gpg_key := /etc/apt/trusted.gpg.d/google-cli.gpg
gcloud_apt_repo := /etc/apt/sources.list.d/google-cloud-sdk.list

$(gcloud_gpg_key):
	$(call header,Terraform - GPG Public Key)
	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o $@

$(gcloud_apt_repo):
	$(call header,terraform - APT repository)
	echo "deb [arch=amd64] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee $@
	sudo apt update

gcloud: gcloud-install gcloud-version

$(gcloud_bin): $(gcloud_gpg_key) $(gcloud_apt_repo)
	$(call header,Google Cloud SDK - Install)
	sudo apt install google-cloud-sdk

gcloud-install: $(gcloud_bin)

gcloud-version:
	$(call header,Google Cloud SDK - Version)
	gcloud --version

###############################################################################
# Hashicorp: APT repository
###############################################################################

hashicorp_gpg_key := /etc/apt/trusted.gpg.d/hashicorp.gpg
hashicorp_apt_repo := /etc/apt/sources.list.d/hashicorp.list

$(hashicorp_gpg_key):
	$(call header,Terraform - GPG Public Key)
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o $@

$(hashicorp_apt_repo):
	$(call header,terraform - APT repository)
	echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release) main" | sudo tee $@
	sudo apt update

###############################################################################
# terraform: Infrastructure as Code
###############################################################################

terraform_bin := /usr/bin/terraform

terraform: terraform-install terraform-version

$(terraform_bin): $(hashicorp_gpg_key) $(hashicorp_apt_repo)
	$(call header,Terraform - Install)
	sudo apt install terraform

terraform-install: $(terraform_bin)

terraform-version:
	$(call header,Terraform - Version)
	terraform --version

###############################################################################
# docker: Container runtime
###############################################################################

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
	sudo apt update

$(code_bin): $(code_gpg) $(code_apt)
	$(call header,Code - Install)
	sudo apt update
	sudo apt install code

code-install: $(code_bin)

code-configure:
	$(call header,Code - Configure)
	ln -rfs $(code_dir)/settings.json $(HOME)/$(code_dir)/settings.json
	ln -rfs $(code_dir)/keybindings.json $(HOME)/$(code_dir)/keybindings.json

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
	sudo apt update

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
	ln -rfs $(mods_config) $(HOME)/$(mods_config)

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
