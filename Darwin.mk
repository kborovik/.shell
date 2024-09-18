###############################################################################
# macOS specific settings
###############################################################################

PATH := /opt/homebrew/bin:$(PATH)

###############################################################################
# Default target
###############################################################################

core-tools: tools posh git gpg git vim bash mods atuin gcloud kubectl k9s terraform

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash_bin := /opt/homebrew/bin/bash
bash_config := .bashrc .bash_logout .profile .digrc
bash_completion := .local/share/bash-completion

$(bash_completion):
	$(call header,Bash - Create directories)
	mkdir -p $(@)

$(bash-bin):
	$(call header,Bash - Install)
	brew install bash bash-completion@2

bash: $(bash_bin)
	$(foreach file,$(bash_config),/bin/ln -fs $(PWD)/$(file) $(HOME)/$(file);)
	/bin/ln -fs $(PWD)/$(bash_completion)/completions $(HOME)/$(bash_completion)

###############################################################################
# Linux tools
###############################################################################

coreutils_bin := /opt/homebrew/Cellar/coreutils
sed_bin := /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed
make_bin := /opt/homebrew/opt/make/libexec/gnubin/make
jq_bin := /opt/homebrew/bin/jq
pass_bin := /opt/homebrew/bin/pass
gh_bin := /opt/homebrew/bin/gh

tools: $(coreutils_bin) $(sed_bin) $(make_bin) $(jq_bin) $(pass_bin) $(gh_bin)

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

$(git_bin):
	$(call header,Git - Install)
	brew install git

git: $(git_bin)
	/bin/ln -fs $(PWD)/.gitconfig $(HOME)/.gitconfig

###############################################################################
# Oh-My-Posh: A prompt theme engine for any shell
###############################################################################

posh_bin := /opt/homebrew/bin/oh-my-posh

$(posh_bin):
	$(call header,POSH - Install)
	brew install oh-my-posh

posh: $(posh_bin)

###############################################################################
# vim: Vi IMproved
###############################################################################

vim_bin := /opt/homebrew/bin/vim

$(vim_bin):
	$(call header,Vim - Install)
	brew install vim

vim: $(vim_bin)
	/bin/ln -fs $(PWD)/.vimrc $(HOME)/.vimrc
	/bin/ln -fs $(PWD)/.vim $(HOME)

###############################################################################
# GPG: GNU Privacy Guard
###############################################################################

gpg_bin := /opt/homebrew/bin/gpg
gpg_dir := $(HOME)/.gnupg
gpg_config := .gnupg/gpg.conf

opensc_bin := /Library/OpenSC/bin/openpgp-tool

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

gpg: $(gpg_bin) $(opensc_bin)
	$(foreach file,$(gpg_config),/bin/ln -fs $(PWD)/$(file) $(HOME)/$(file);)

###############################################################################
# k9s: A terminal-based UI to interact with your Kubernetes clusters
###############################################################################

k9s_bin := /opt/homebrew/bin/k9s
k9s_dir := $(HOME)/Library/Application\ Support/k9s
k9s_config := aliases.yaml config.yaml hotkeys.yaml
k9s_skin := skins/onedark.yaml

$(k9s_bin):
	$(call header,k9s - Install)
	brew install k9s

k9s: $(k9s_bin)
	$(foreach file,$(k9s_config),/bin/ln -fs $(PWD)/.config/k9s/$(file) $(k9s_dir)/$(file);)
	/bin/ln -fs $(PWD)/.config/k9s/$(k9s_skin) $(k9s_dir)/$(k9s_skin)

###############################################################################
# Code: Visual Studio Code
###############################################################################

code_bin := /opt/homebrew/bin/code

$(code_bin):
	$(call header,Code - Install)
	brew install --cask visual-studio-code

code: $(code_bin)

###############################################################################
# Mods: AI for the command line, built for pipelines.
# https://github.com/charmbracelet/mods
###############################################################################

mods_bin := /opt/homebrew/bin/mods
mods_dir := $(HOME)/Library/Application\ Support/mods
mods_config := $(HOME)/Library/Application\ Support/mods/mods.yml

$(mods_dir):
	$(call header,Mods - Create directories)
	mkdir -p $(@)

$(mods_bin):
	$(call header,Mods - Install) 
	brew install mods

mods: $(mods_bin)
	$(call header,Mods - Configure)
	$(eval OPENAI_API_KEY := $(shell pass openai/OPENAI_API_KEY))
	$(eval ANTHROPIC_API_KEY := $(shell pass anthropic/ANTHROPIC_API_KEY))
	$(eval PERPLEXITY_API_KEY := $(shell pass perplexity/PERPLEXITY_API_KEY))
	$(eval GROQ_API_KEY := $(shell pass groq/GROQ_API_KEY))
	set -e
	cp .config/mods/mods.yml $(mods_config)
	yq -i '.apis.openai.api-key = "$(OPENAI_API_KEY)"' $(mods_config)
	yq -i '.apis.anthropic.api-key = "$(ANTHROPIC_API_KEY)"' $(mods_config)
	yq -i '.apis.perplexity.api-key = "$(PERPLEXITY_API_KEY)"' $(mods_config)
	yq -i '.apis.groq.api-key = "$(GROQ_API_KEY)"' $(mods_config)

###############################################################################
# Google Cloud SDK
###############################################################################

gcloud_bin := /opt/homebrew/bin/gcloud

$(gcloud_bin):
	$(call header,Google Cloud SDK - Install)
	brew install --cask google-cloud-sdk

gcloud: $(gcloud_bin)

###############################################################################
# kubectl: The Kubernetes command-line tool
###############################################################################

kubectl_bin := /opt/homebrew/bin/kubectl

$(kubectl_bin):
	$(call header,kubectl - Install)
	brew install kubernetes-cli

kubectl: $(kubectl_bin)

###############################################################################
# helm: The Kubernetes Package Manager
###############################################################################

helm_bin := /opt/homebrew/bin/helm

$(helm_bin):
	$(call header,helm - Install)
	brew install helm

helm: $(helm_bin)

###############################################################################
# Terraform: Infrastructure as Code
###############################################################################

terraform_bin := /opt/homebrew/bin/terraform

$(terraform_bin):
	$(call header,Terraform - Install)
	brew tap hashicorp/tap
	brew install hashicorp/tap/terraform

terraform: $(terraform_bin)
