###############################################################################
# macOS specific settings
###############################################################################

PATH := /opt/homebrew/bin:$(PATH)

###############################################################################
# Default target
###############################################################################

core-tools: tools fish git gpg git vim bash

###############################################################################
# Fish: The Friendly Interactive SHell
###############################################################################

fish_bin := /opt/homebrew/bin/fish
fish_dir := .config/fish/

$(fish_bin):
	$(call header,Fish - Install)
	brew install fish

$(fish_bin):
	mkdir -p $(fish_dir)

fish: $(fish_bin)
	$(call header,Fish - Configure)
	/bin/ln -fs $(PWD)/$(fish_dir) $(HOME)/$(fish_dir)

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

gpg: $(gpg_dir) $(gpg_bin) $(opensc_bin)
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
# yq: A portable command-line YAML processor
###############################################################################

yq_bin := /opt/homebrew/bin/yq

$(yq_bin):
	$(call header,yq - Install)
	brew install yq

yq: $(yq_bin)

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
	brew install charmbracelet/tap/mods

mods: $(yq_bin) $(mods_dir) $(mods_bin)
	$(call header,Mods - Configure)
	$(eval ANTHROPIC_API_KEY := $(shell pass anthropic/ANTHROPIC_API_KEY))
	$(eval GEMINI_API_KEY := $(shell pass google/GEMINI_API_KEY))
	$(eval OPENAI_API_KEY := $(shell pass openai/OPENAI_API_KEY))
	set -e
	cp .config/mods/mods.yml $(mods_config)
	yq -i '.apis.anthropic.api-key = "$(ANTHROPIC_API_KEY)"' $(mods_config)
	yq -i '.apis.google.api-key = "$(GEMINI_API_KEY)"' $(mods_config)
	yq -i '.apis.openai.api-key = "$(OPENAI_API_KEY)"' $(mods_config)

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

###############################################################################
# bat: A cat(1) clone with wings https://github.com/sharkdp/bat
###############################################################################

bat_bin := /opt/homebrew/bin/bat

$(bat_bin):
	$(call header,bat - Install)
	brew install bat

bat: $(bat_bin)
	$(call header,bat - Config)
	mkdir -p $(HOME)/.config/bat
	ln -rfs .config/bat/config $(HOME)/.config/bat/config
