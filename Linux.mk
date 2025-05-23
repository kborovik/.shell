###############################################################################
# Linux specific settings
###############################################################################

PATH := $(local_bin):$(PATH)

ARCH := $(shell dpkg --print-architecture)

# lsb_release := $(shell lsb_release -cs)
lsb_release := noble
lsb_id := $(shell lsb_release -is)
local_bin := $(HOME)/.local/bin

ifneq ($(lsb_id),Ubuntu)
$(error ==> Only Ubuntu supported <==)
endif

###############################################################################
# Default target
###############################################################################

core-tools: apt-update tools fish git gpg vim

###############################################################################
# General functions
###############################################################################

$(local_bin):
	$(call header,Local Bin directory)
	mkdir -p $(@)

apt-update:
	$(call header,APT - Update)
	sudo apt update

###############################################################################
# Linux tools
###############################################################################

curl_bin := /usr/bin/curl
tree_bin := /usr/bin/tree
unzip_bin := /usr/bin/unzip
jq_bin := /usr/bin/jq

$(curl_bin):
	$(call header,curl - Install)
	sudo apt-get --yes install curl && sudo touch $(@)

$(tree_bin):
	$(call header,tree - Install)
	sudo apt-get --yes install tree && sudo touch $(@)

$(unzip_bin):
	$(call header,unzip - Install)
	sudo apt-get --yes install unzip && sudo touch $(@)

$(jq_bin):
	$(call header,jq - Install)
	sudo apt-get --yes install jq && sudo touch $(@)

tools: $(tree_bin) $(unzip_bin) $(curl_bin) $(jq_bin)

###############################################################################
# Fish: The Friendly Interactive SHell
###############################################################################

fish_bin := /usr/bin/fish
fish_dir := .config/fish

$(fish_bin):
	$(call header,Fish - Install)
	sudo apt install fish

fish: $(fish_bin)
	ln -rfs $(fish_dir) $(HOME)/.config/

###############################################################################
# Git: Distributed version control system
###############################################################################

git_bin := /usr/bin/git

$(git_bin):
	$(call header,Git - Install)
	sudo apt-get --yes install git && sudo touch $(@)

git: $(git_bin)
	ln -rfs .gitconfig $(HOME)/.gitconfig

###############################################################################
# Pass: Password manager
###############################################################################

pass_bin := /usr/bin/pass

$(pass_bin):
	$(call header,Pass - Install)
	sudo apt-get --yes install pass && sudo touch $(@)

pass: $(pass_bin)

###############################################################################
# Zed Editor
###############################################################################

zed_bin := $(HOME)/.local/zed.app/bin/zed
zed_dir := .config/zed

$(zed_bin):
	$(call header,Zed - Install)
	curl -f https://zed.dev/install.sh | sh

$(zed_dir):
	mkdir -p $(@)

zed: $(zed_dir) $(zed_bin)
	ln -rfs $(zed_dir)/keymap.json $(HOME)/$(zed_dir)/keymap.json
	ln -rfs $(zed_dir)/settings.json $(HOME)/$(zed_dir)/settings.json

###############################################################################
# vim: Vi IMproved
###############################################################################

vim_bin := /usr/bin/vim

$(vim_bin):
	$(call header,Vim - Install)
	sudo apt-get --yes install vim && sudo touch $(@)

vim: $(vim_bin)
	ln -rfs .vimrc $(HOME)/.vimrc
	ln -rfs .vim $(HOME)

###############################################################################
# uv: Python Virtual Environment Manager
###############################################################################

uv_bin := $(HOME)/.local/bin/uv

$(uv_bin):
	curl -LsSf https://astral.sh/uv/install.sh | sh

uv: $(uv_bin)

###############################################################################
# ruff: Python linter
###############################################################################

ruff_bin := $(HOME)/.local/bin/ruff

$(ruff_bin):
	curl -LsSf https://astral.sh/ruff/install.sh | sh

ruff: $(ruff_bin)

###############################################################################
# bat: A cat(1) clone with wings https://github.com/sharkdp/bat
###############################################################################

bat_bin := /usr/bin/batcat
bat_link := /usr/bin/bat
bat_dir := .config/bat

$(bat_bin):
	$(call header,bat - Install)
	sudo apt install bat

$(bat_link):
	$(call header,bat - Link)
	sudo update-alternatives --install $(bat_link) bat $(bat_bin) 0

bat: $(bat_bin) $(bat_link)
	$(call header,bat - Config)
	ln -rfs .config/bat $(HOME)/.config/bat


###############################################################################
# GPG: GNU Privacy Guard
###############################################################################

scdaemon_bin := /usr/lib/gnupg/scdaemon
gpg_bin := /usr/bin/gpg
gpg_dir := $(HOME)/.gnupg
gpg_config := .gnupg/gpg.conf

$(scdaemon_bin):
	$(call header,GPG - Install scdaemon)
	sudo apt-get --yes install scdaemon && sudo touch $(@)

$(gpg_dir):
	$(call header,GPG - Directories)
	mkdir -p $(@)
	chmod 700 $(@)

$(gpg_bin):
	$(call header,GPG - Install)
	sudo apt-get --yes install gnupg && sudo touch $(@)

gpg: $(gpg_bin) $(scdaemon_bin) $(gpg_dir)
	ln -rfs $(PWD)/$(gpg_config) $(HOME)/$(gpg_config)

###############################################################################
# yq: YAML processor
###############################################################################

yq_bin := $(HOME)/.local/bin/yq

$(yq_bin):
	$(call header,yq - Install)
	set -e
	curl -sSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o yq_linux_amd64
	curl -sSL https://github.com/mikefarah/yq/releases/latest/download/checksums-bsd -o checksums-bsd
	sha256sum --check --status --ignore-missing checksums-bsd
	rm checksums-bsd
	mv yq_linux_amd64 $(@)
	chmod +x $(@)

yq: $(yq_bin)

###############################################################################
# Ubuntu Desktop GNOME Terminal
###############################################################################

gnome-terminal:
	$(call header,GNOME Terminal - Configure)
	sudo apt install fonts-ibm-plex
	gsettings set org.gnome.desktop.interface text-scaling-factor '1.5'
	dconf load '/org/gnome/terminal/legacy/' < Linux/gnome.dconf

###############################################################################
# gcloud: Google Cloud SDK
###############################################################################

gcloud_bin := /usr/bin/gcloud
gke_auth_plugin := /usr/lib/google-cloud-sdk/bin/gke-gcloud-auth-plugin
gcloud_gpg_key := /etc/apt/trusted.gpg.d/google-packages.gpg
gcloud_apt_repo := /etc/apt/sources.list.d/google-packages.list

$(gcloud_gpg_key):
	$(call header,Google - GPG Public Key)
	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o $(@)

$(gcloud_apt_repo):
	$(call header,Google - APT repository)
	echo "deb [arch=amd64] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee $(@)
	sudo apt update

$(gcloud_bin): $(gcloud_gpg_key) $(gcloud_apt_repo)
	$(call header,Google Cloud SDK - Install)
	sudo apt-get --yes install google-cloud-cli && sudo touch $(@)

$(gke_auth_plugin): $(gcloud_bin)
	$(call header,Google GKE Auth Plugin - Install)
	sudo apt-get --yes install google-cloud-cli-gke-gcloud-auth-plugin && sudo touch $(@)

google: $(gcloud_bin) $(gke_auth_plugin)

###############################################################################
# kubectl: Kubernetes CLI
###############################################################################

kubectl_bin := /usr/bin/kubectl

$(kubectl_bin): $(gcloud_gpg_key) $(gcloud_apt_repo)
	$(call header,kubectl - Install)
	sudo apt-get --yes install kubectl && sudo touch $(@)

kubectl: $(kubectl_bin)

###############################################################################
# HELM: The package manager for Kubernetes
###############################################################################

helm_bin := /usr/local/bin/helm

$(helm_bin):
	$(call header,helm - Install)
	curl -sSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm: $(helm_bin)

###############################################################################
# Brave Browser: Chromium-based browser focused on privacy
###############################################################################

brave_gpg_key := /etc/apt/trusted.gpg.d/brave-browser-archive-keyring.gpg
brave_apt_repo := /etc/apt/sources.list.d/brave-browser-release.list
brave_bin := /usr/bin/brave-browser

$(brave_gpg_key):
	$(call header,Brave Browser - GPG Public Key)
	curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | sudo gpg --dearmor -o $(@)

$(brave_apt_repo):
	$(call header,Brave Browser - APT repository)
	echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com stable main" | sudo tee $(@)
	sudo apt update

$(brave_bin): $(brave_gpg_key) $(brave_apt_repo)
	$(call header,Brave Browser - Install)
	sudo apt-get --yes install brave-browser && sudo touch $(@)

brave: $(brave_bin)

###############################################################################
# Hashicorp: APT repository
###############################################################################

hashicorp_gpg_key := /etc/apt/trusted.gpg.d/hashicorp.gpg
hashicorp_apt_repo := /etc/apt/sources.list.d/hashicorp.list

$(hashicorp_gpg_key):
	$(call header,Hashicorp - GPG Public Key)
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o $(@)

$(hashicorp_apt_repo):
	$(call header,Hashicorp - APT repository)
	echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release) main" | sudo tee $(@)
	sudo apt update

###############################################################################
# terraform: Infrastructure as Code
###############################################################################

terraform_bin := /usr/bin/terraform

$(terraform_bin): $(hashicorp_gpg_key) $(hashicorp_apt_repo)
	$(call header,Terraform - Install)
	sudo apt-get --yes install terraform && sudo touch $(@)

terraform: $(terraform_bin)

###############################################################################
# docker: Container runtime
###############################################################################

docker_bin := /usr/bin/docker
docker_gpg := /etc/apt/trusted.gpg.d/docker.gpg
docker_apt := /etc/apt/sources.list.d/docker.list

$(docker_gpg):
	$(call header,Docker - GPG Public Key)
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o $(@)

$(docker_apt):
	$(call header,Docker - APT Repository)
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release) stable" | sudo tee $(@)
	sudo apt update

$(docker_bin): $(docker_gpg) $(docker_apt)
	$(call header,Docker - Install)
	sudo apt-get --yes install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo touch $(@)

docker: $(docker_bin)
	sudo usermod -aG docker $(USER)

###############################################################################
# github: GitHub CLI
###############################################################################

gh_bin := /usr/bin/gh

$(gh_bin):
	$(call header,gh - Install)
	sudo apt-get --yes install gh
	sudo touch $(@)

gh: $(gh_bin)

###############################################################################
# Python tools: pipx
###############################################################################

pipx_bin := /usr/bin/pipx

$(pipx_bin):
	$(call header,pipx - Install)
	sudo apt-get --yes install pipx && sudo touch $(@)

pipx: $(pipx_bin)

###############################################################################
# Ansible: Automation for everyone
###############################################################################

ansible_bin := /home/kb/.local/bin/ansible
ansible_lint := /home/kb/.local/bin/ansible-lint

$(ansible_bin): $(pipx_bin)
	$(call header,Ansible - Install)
	pipx install ansible-core && touch $(@)

$(ansible_lint): $(pipx_bin)
	$(call header,Ansible-Lint - Install)
	pipx install ansible-lint && touch $(@)

ansible: $(ansible_bin) $(ansible_lint)

###############################################################################
# zfs-autobackup: ZFS snapshot and backup automation
###############################################################################

zfs-autobackup: $(pipx_bin)
	$(call header,zfs-autobackup - Install)
	sudo pipx install --global zfs-autobackup

###############################################################################
# k9s: A terminal-based UI to interact with your Kubernetes clusters
###############################################################################

k9s_bin := ~/.local/bin/k9s
k9s_dir := ~/.config/k9s ~/.config/k9s/skins
k9s_config := ~/.config/k9s/config.yaml ~/.config/k9s/hotkeys.yaml ~/.config/k9s/aliases.yaml ~/.config/k9s/skins/onedark.yaml

$(k9s_dir):
	mkdir -p $(@)

$(k9s_config):
	ln -rfs $(subst $(HOME),$(CURDIR),$(@)) $(@)

$(k9s_bin):
	$(call header,k9s - Install)
	set -e
	cd /tmp
	curl -sSL https://github.com/derailed/k9s/releases/latest/download/checksums.sha256 -o checksums.sha256
	curl -sSL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz -o k9s_Linux_amd64.tar.gz
	sha256sum --check --status --ignore-missing checksums.sha256
	tar -xzf k9s_Linux_amd64.tar.gz
	mv k9s $(@)
	touch $(@)
	rm -rf k9s_Linux_amd64.tar.gz checksums.sha256

k9s: $(k9s_bin) $(k9s_dir) $(k9s_config)

###############################################################################
# TUI Library and Apps
# https://github.com/charmbracelet
###############################################################################

charm_gpg_key := /etc/apt/trusted.gpg.d/charm.gpg
charm_apt_repo := /etc/apt/sources.list.d/charm.list

$(charm_gpg_key):
	$(call header,Charm - GPG Public Key)
	curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o $(@)

$(charm_apt_repo):
	$(call header,Charm - APT repository)
	echo "deb [signed-by=$(charm_gpg_key)] https://repo.charm.sh/apt/ * *" | sudo tee $(@)
	sudo apt update

###############################################################################
# Mods: AI for the command line, built for pipelines.
# https://github.com/charmbracelet/mods
###############################################################################

mods_bin := /usr/bin/mods
mods_dir := $(HOME)/.config/mods
mods_config := .config/mods/mods.yml

$(mods_dir):
	mkdir -p $(@)

$(mods_bin): $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Mods - Install)
	sudo apt-get --yes install mods && sudo touch $(@)

mods: $(mods_dir) $(mods_bin) $(yq_bin)
	$(call header,Mods - Configure)
	$(eval ANTHROPIC_API_KEY := $(shell pass anthropic/ANTHROPIC_API_KEY))
	$(eval GEMINI_API_KEY := $(shell pass google/GEMINI_API_KEY))
	$(eval OPENAI_API_KEY := $(shell pass openai/OPENAI_API_KEY))
	cp --remove-destination $(mods_config) $(HOME)/$(mods_config)
	yq -i '.apis.anthropic.api-key = "$(ANTHROPIC_API_KEY)"' $(HOME)/$(mods_config)
	yq -i '.apis.google.api-key = "$(GEMINI_API_KEY)"' $(HOME)/$(mods_config)
	yq -i '.apis.openai.api-key = "$(OPENAI_API_KEY)"' $(HOME)/$(mods_config)

###############################################################################
# VHS: Write terminal GIFs as code
# https://github.com/charmbracelet/vhs
###############################################################################

vhs_bin := /usr/bin/vhs
ffmpeg_bin := /usr/bin/ffmpeg
ttyd_bin := $(HOME)/.local/bin/ttyd

$(ffmpeg_bin):
	$(call header,VHS - Install ffmpeg)
	sudo apt-get --yes install ffmpeg && sudo touch $(@)

$(ttyd_bin):
	$(call header,VHS - Install ttyd)
	set -e
	curl -sSL https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -o ttyd.x86_64
	curl -sSL https://github.com/tsl0922/ttyd/releases/latest/download/SHA256SUMS -o SHA256SUM
	sha256sum --check --status --ignore-missing SHA256SUM
	rm SHA256SUM
	mv ttyd.x86_64 $(@) && chmod +x $(@)

$(vhs_bin): $(charm_gpg_key) $(charm_apt_repo)
	$(call header,VHS - Install)
	sudo apt-get --yes install vhs && sudo touch $(@)

vhs: $(ffmpeg_bin) $(ttyd_bin) $(vhs_bin)

vhs-uninstall:
	$(call header,VHS - Uninstall)
	sudo apt remove vhs ffmpeg
	sudo apt -y autoremove
	rm $(ttyd_bin)

vhs-version:
	$(call header,VHS - Version)
	vhs --version
	ttyd --version
