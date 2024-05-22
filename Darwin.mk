###############################################################################
# macOS specific settings
###############################################################################

PATH := /opt/homebrew/bin:$(PATH)

###############################################################################
# Default target
###############################################################################

install: tools posh git gpg git vim bash mods atuin gcloud kubectl k9s terraform

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
	$(foreach file,$(bash_config),/bin/ln -fs $(PWD)/$(file) $(HOME)/$(file);)
	/bin/ln -fs $(PWD)/$(bash_completion)/completions $(HOME)/$(bash_completion)

bash-version:
	$(call header,Bash - Version)
	bash --version

###############################################################################
# Linux tools
###############################################################################

coreutils_bin := /opt/homebrew/Cellar/coreutils
sed_bin := /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed
make_bin := /opt/homebrew/opt/make/libexec/gnubin/make
jq_bin := /opt/homebrew/bin/jq
pass_bin := /opt/homebrew/bin/pass
gh_bin := /opt/homebrew/bin/gh

tools: $(coreutils_bin) $(jq_bin) $(pass_bin) $(gh_bin)

$(coreutils_bin):
	$(call header,coreutils - Install)
	brew install coreutils

$(sed_bin):
	$(call header,sed - Install)
	brew install gnu-sed

$(make_bin):
	$(call header,make - Install)
	brew install make

$(jq_bin):
	$(call header,jq - Install)
	brew install jq

$(pass_bin):
	$(call header,pass - Install)
	brew install pass

$(gh_bin):
	$(call header,gh - Install)
	brew install gh

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
	/bin/ln -fs $(PWD)/.gitconfig $(HOME)/.gitconfig

###############################################################################
# Oh-My-Posh: A prompt theme engine for any shell
###############################################################################

posh_bin := /opt/homebrew/bin/oh-my-posh

posh: posh-install posh-version

$(posh_bin):
	$(call header,POSH - Install)
	brew install oh-my-posh

posh-install: $(posh_bin)

posh-uninstall:
	$(call header,POSH - Uninstall)
	brew rm oh-my-posh

posh-version:
	$(call header, POSH - Version)
	$(posh_bin) --version

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
	/bin/ln -fs $(PWD)/.vimrc $(HOME)/.vimrc
	/bin/ln -fs $(PWD)/.vim $(HOME)

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
	$(foreach file,$(gpg_config),/bin/ln -fs $(PWD)/$(file) $(HOME)/$(file);)

gpg-version:
	$(call header,GPG - Version)
	gpg --version

###############################################################################
# k9s: A terminal-based UI to interact with your Kubernetes clusters
###############################################################################

k9s_bin := /opt/homebrew/bin/k9s
k9s_dir := $(HOME)/Library/Application\ Support/k9s
k9s_config := aliases.yaml config.yaml hotkeys.yaml
k9s_skin := skins/onedark.yaml

k9s: k9s-install k9s-version

$(k9s_bin):
	$(call header,k9s - Install)
	brew install k9s

k9s-install: $(k9s_bin)

k9s-configure:
	$(call header,k9s - Configure)
	$(foreach file,$(k9s_config),/bin/ln -fs $(PWD)/.config/k9s/$(file) $(k9s_dir)/$(file);)
	/bin/ln -fs $(PWD)/.config/k9s/$(k9s_skin) $(k9s_dir)/$(k9s_skin)

k9s-version:
	$(call header,k9s - Version)
	k9s version

###############################################################################
# Code: Visual Studio Code
###############################################################################

code_bin := /opt/homebrew/bin/code

$(code_bin):
	$(call header,Code - Install)
	brew install --cask visual-studio-code

code: code-install code-version

code-install: $(code_bin)

code-version:
	$(call header,Code - Version)
	code --version

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
	/bin/ln -fs $(PWD)/.config/mods/mods.yml $(mods_config)

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
# kubectl: The Kubernetes command-line tool
###############################################################################

kubectl_bin := /opt/homebrew/share/google-cloud-sdk/bin/kubectl

$(kubectl_bin): $(gcloud_bin)
	$(call header,kubectl - Install)
	gcloud components install kubectl --quiet

kubectl: kubectl-install kubectl-version

kubectl-install: $(kubectl_bin)

kubectl-version:
	$(call header,kubectl - Version)
	kubectl version --client --output=yaml

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
