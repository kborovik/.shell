###############################################################################
# Linux specific settings
###############################################################################

PATH := $(local_bin):$(PATH)

ARCH := $(shell dpkg --print-architecture)

lsb_release := $(shell lsb_release -cs)
lsb_id := $(shell lsb_release -is)
local_bin := $(HOME)/.local/bin

ifneq ($(lsb_id),Ubuntu)
$(error ==> Only Ubuntu supported <==)
endif

###############################################################################
# Default target
###############################################################################

core-tools: apt-update tools posh bash git gpg vim

###############################################################################
# General functions
###############################################################################

$(local_bin):
	$(call header,Local Bin directory)
	mkdir -p $@

apt-update:
	$(call header,APT - Update)
	sudo apt update

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash_config := .bashrc .bash_logout .profile .digrc
bash_completion := .local/share/bash-completion
bash_dir := $(HOME)/$(bash_completion)

$(bash_dir):
	$(call header,Bash - Create directories)
	mkdir -p $(@)

bash: $(bash_dir)
	$(foreach file,$(bash_config),ln -rfs $(file) $(HOME)/$(file);)
	ln -rfs $(bash_completion)/completions $(HOME)/$(bash_completion)

###############################################################################
# Linux tools
###############################################################################

curl_bin := /usr/bin/curl
pass_bin := /usr/bin/pass
tree_bin := /usr/bin/tree
unzip_bin := /usr/bin/unzip

$(curl_bin):
	$(call header,curl - Install)
	sudo apt-get --yes install curl
	sudo touch $@

$(pass_bin):
	$(call header,pass - Install)
	sudo apt-get --yes install pass
	sudo touch $@

$(tree_bin):
	$(call header,tree - Install)
	sudo apt-get --yes install tree
	sudo touch $@

$(unzip_bin):
	$(call header,unzip - Install)
	sudo apt-get --yes install unzip
	sudo touch $@

tools: $(tree_bin) $(unzip_bin) $(pass_bin) $(curl_bin)

###############################################################################
# Git: Distributed version control system
###############################################################################

git_bin := /usr/bin/git

$(git_bin):
	$(call header,Git - Install)
	sudo apt-get --yes install git
	sudo touch $@

git: $(git_bin)
	ln -rfs .gitconfig $(HOME)/.gitconfig

###############################################################################
# Oh-My-Posh: A prompt theme engine for any shell
###############################################################################

posh_bin := $(HOME)/.local/bin/oh-my-posh

$(posh_bin): $(unzip_bin)
	$(call header,POSH - Install)
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $(local_bin)

posh: $(local_bin) $(posh_bin)

posh-upgrade:
	$(call header,POSH - Upgrade)
	oh-my-posh version
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $(local_bin)
	oh-my-posh version

###############################################################################
# vim: Vi IMproved
###############################################################################

vim_bin := /usr/bin/vim

$(vim_bin):
	$(call header,Vim - Install)
	sudo apt-get --yes install vim
	sudo touch $@

vim: $(vim_bin)
	ln -rfs .vimrc $(HOME)/.vimrc
	ln -rfs .vim $(HOME)

###############################################################################
# GPG: GNU Privacy Guard
###############################################################################

scdaemon_bin := /usr/lib/gnupg/scdaemon
gpg_bin := /usr/bin/gpg
gpg_dir := $(HOME)/.gnupg
gpg_config := .gnupg/gpg.conf .gnupg/scdaemon.conf .gnupg/gpg-agent.conf

$(scdaemon_bin):
	$(call header,GPG - Install scdaemon)
	sudo apt-get --yes install scdaemon
	sudo touch $@

$(gpg_dir):
	$(call header,GPG - Directories)
	mkdir -p $(@)
	chmod 700 $(@)

$(gpg_bin):
	$(call header,GPG - Install)
	sudo apt-get --yes install gnupg
	sudo touch $@

gpg: $(gpg_bin) $(scdaemon_bin) $(gpg_dir)
	$(foreach file,$(gpg_config),ln -rfs $(file) $(HOME)/$(file);)

###############################################################################
# gcloud: Google Cloud SDK
###############################################################################

gcloud_bin := /usr/bin/gcloud
gke_auth_plugin := /usr/lib/google-cloud-sdk/bin/gke-gcloud-auth-plugin
gcloud_gpg_key := /etc/apt/trusted.gpg.d/google-packages.gpg
gcloud_apt_repo := /etc/apt/sources.list.d/google-packages.list

$(gcloud_gpg_key):
	$(call header,Terraform - GPG Public Key)
	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o $@

$(gcloud_apt_repo):
	$(call header,terraform - APT repository)
	echo "deb [arch=amd64] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee $@
	sudo apt update

$(gcloud_bin): $(gcloud_gpg_key) $(gcloud_apt_repo)
	$(call header,Google Cloud SDK - Install)
	sudo apt-get --yes install google-cloud-sdk
	sudo touch $@

$(gke_auth_plugin): $(gcloud_bin)
	$(call header,Google GKE Auth Plugin - Install)
	sudo apt-get --yes install google-cloud-cli-gke-gcloud-auth-plugin
	sudo touch $@

gcloud: $(gcloud_bin) $(gke_auth_plugin)

###############################################################################
# kubectl: Kubernetes CLI
###############################################################################

kubectl_bin := /usr/bin/kubectl

$(kubectl_bin):
	$(call header,kubectl - Install)
	sudo apt-get --yes install kubectl
	sudo touch $@

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
# Brave Browser: Chromium-based browser focused on privacy
###############################################################################

brave_gpg_key := /etc/apt/trusted.gpg.d/brave-browser-archive-keyring.gpg
brave_apt_repo := /etc/apt/sources.list.d/brave-browser-release.list
brave_bin := /usr/bin/brave-browser

$(brave_gpg_key):
	$(call header,Brave Browser - GPG Public Key)
	curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | sudo gpg --dearmor -o $@

$(brave_apt_repo):
	$(call header,Brave Browser - APT repository)
	echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com stable main" | sudo tee $@
	sudo apt update

$(brave_bin): $(brave_gpg_key) $(brave_apt_repo)
	$(call header,Brave Browser - Install)
	sudo apt-get --yes install brave-browser
	sudo touch $@

brave: $(brave_bin)

###############################################################################
# Hashicorp: APT repository
###############################################################################

hashicorp_gpg_key := /etc/apt/trusted.gpg.d/hashicorp.gpg
hashicorp_apt_repo := /etc/apt/sources.list.d/hashicorp.list

$(hashicorp_gpg_key):
	$(call header,Hashicorp - GPG Public Key)
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o $@

$(hashicorp_apt_repo):
	$(call header,Hashicorp - APT repository)
	echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release) main" | sudo tee $@
	sudo apt update

###############################################################################
# terraform: Infrastructure as Code
###############################################################################

terraform_bin := /usr/bin/terraform

$(terraform_bin): $(hashicorp_gpg_key) $(hashicorp_apt_repo)
	$(call header,Terraform - Install)
	sudo apt-get --yes install terraform
	sudo touch $@

terraform: $(terraform_bin)

###############################################################################
# docker: Container runtime
###############################################################################

docker_bin := /usr/bin/docker
docker_gpg := /etc/apt/trusted.gpg.d/docker.gpg
docker_apt := /etc/apt/sources.list.d/docker.list

$(docker_gpg):
	$(call header,Docker - GPG Public Key)
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o $@

$(docker_apt):
	$(call header,Docker - APT Repository)
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release) stable" | sudo tee $@
	sudo apt update

$(docker_bin): $(docker_gpg) $(docker_apt)
	$(call header,Docker - Install)
	sudo apt-get --yes install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo touch $@

docker: $(docker_bin)
	sudo usermod -aG docker $(USER)

###############################################################################
# NVIDIA Container Toolkit
###############################################################################

nvidia_gpg := /etc/apt/trusted.gpg.d/nvidia-container-toolkit.gpg
nvidia_apt := /etc/apt/sources.list.d/nvidia-container-toolkit.list
nvidia_hook := /usr/bin/nvidia-container-runtime-hook

$(nvidia_gpg):
	$(call header,NVIDIA - GPG Public Key)
	curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o $@

$(nvidia_apt):
	$(call header,NVIDIA - APT repository)
	echo "deb [signed-by=$(nvidia_gpg)] https://nvidia.github.io/libnvidia-container/stable/deb/$(ARCH) /" | sudo tee $@

$(nvidia_hook): $(nvidia_gpg) $(nvidia_apt)
	$(call header,NVIDIA - Install)
	sudo apt-get --yes install nvidia-container-toolkit
	sudo touch $@

nvidia-config: $(docker)
	if ! jq -e '.runtimes.nvidia.path' /etc/docker/daemon.json > /dev/null 2>&1; then
		sudo nvidia-ctk runtime configure --runtime=docker
		sudo systemctl restart docker
	fi

nvidia: $(nvidia_hook) nvidia-config

###############################################################################
# github: GitHub CLI
###############################################################################

gh_bin := /usr/bin/gh

$(gh_bin):
	$(call header,gh - Install)
	sudo apt-get --yes install gh
	sudo touch $@

gh: $(gh_bin)

###############################################################################
# Python tools
###############################################################################

pipx_bin := /usr/bin/pipx

$(pipx_bin):
	$(call header,pipx - Install)
	sudo apt-get --yes install pipx
	sudo touch $@

pipx: $(pipx_bin)

###############################################################################
# Ansible: Automation for everyone
###############################################################################

ansible_bin := /home/kb/.local/bin/ansible
ansible_lint := /home/kb/.local/bin/ansible-lint

$(ansible_bin): $(pipx_bin)
	$(call header,Ansible - Install)
	pipx install ansible-core
	touch $@

$(ansible_lint): $(pipx_bin)
	$(call header,Ansible-Lint - Install)
	pipx install ansible-lint
	touch $@

ansible: $(ansible_bin) $(ansible_lint)

###############################################################################
# zfs-autobackup: ZFS snapshot and backup automation
###############################################################################

zfs_autobackup := /home/kb/.local/bin/zfs-autobackup

$(zfs_autobackup): $(pipx_bin)
	$(call header,zfs-autobackup - Install)
	pipx install zfs-autobackup

zfs-autobackup: $(zfs_autobackup)
	sudo ln -rfs /usr/local/bin/zfs-autobackup $(zfs_autobackup)

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
# Code: Visual Studio Code
###############################################################################
code_bin := /usr/bin/code
code_dir := .config/Code/User
code_gpg := /etc/apt/trusted.gpg.d/microsoft.gpg
code_apt := /etc/apt/sources.list.d/vscode.list

$(code_dir):
	$(call header,Code - Directories)
	mkdir -p $@

$(code_gpg):
	$(call header,Code - Microsoft GPG Public Key)
	curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o $@

$(code_apt):
	$(call header,Code - APT Repository)
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee $@
	sudo apt update

$(code_bin): $(code_gpg) $(code_apt)
	$(call header,Code - Install)
	sudo apt-get --yes install code
	sudo touch $@

code: $(code_bin)
	ln -rfs $(code_dir)/settings.json $(HOME)/$(code_dir)/settings.json
	ln -rfs $(code_dir)/keybindings.json $(HOME)/$(code_dir)/keybindings.json
	ln -rfs $(code_dir)/cody.json $(HOME)/.vscode/cody.json

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

$(mods_bin): $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Mods - Install)
	sudo apt update
	sudo apt-get --yes install mods
	sudo touch $@

mods: $(mods_bin) $(yq_bin)
	$(call header,Mods - Configure)
	$(eval OPENAI_API_KEY := $(shell pass openai/OPENAI_API_KEY))
	$(eval ANTHROPIC_API_KEY := $(shell pass anthropic/ANTHROPIC_API_KEY))
	$(eval PERPLEXITY_API_KEY := $(shell pass perplexity/PERPLEXITY_API_KEY))
	$(eval GROQ_API_KEY := $(shell pass groq/GROQ_API_KEY))
	cp --remove-destination $(mods_config) $(HOME)/$(mods_config)
	yq -i '.apis.openai.api-key = "$(OPENAI_API_KEY)"' $(HOME)/$(mods_config)
	yq -i '.apis.anthropic.api-key = "$(ANTHROPIC_API_KEY)"' $(HOME)/$(mods_config)
	yq -i '.apis.perplexity.api-key = "$(PERPLEXITY_API_KEY)"' $(HOME)/$(mods_config)
	yq -i '.apis.groq.api-key = "$(GROQ_API_KEY)"' $(HOME)/$(mods_config)

###############################################################################
# VHS: Write terminal GIFs as code
# https://github.com/charmbracelet/vhs
###############################################################################

vhs_bin := /usr/bin/vhs
ffmpeg_bin := /usr/bin/ffmpeg
ttyd_bin := $(HOME)/.local/bin/ttyd

$(ffmpeg_bin):
	$(call header,VHS - Install ffmpeg)
	sudo apt-get --yes install ffmpeg
	sudo touch $@

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
	sudo apt-get --yes install vhs
	sudo touch $@

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

###############################################################################
# Glow: Render markdown on the CLI
# https://github.com/charmbracelet/glow
###############################################################################

glow_bin := /usr/bin/glow

$(glow_bin): $(charm_gpg_key) $(charm_apt_repo)
	$(call header,Glow - Install)
	sudo apt-get --yes install glow
	sudo touch $@

glow: $(glow_bin)

###############################################################################
# Ollama: A CLI for the Ollama API
# https://ollama.com/download/linux
###############################################################################

ollama_bin := /usr/local/bin/ollama

$(ollama_bin):
	$(call header,Ollama - Install)
	curl -fsSL https://ollama.com/download/linux | sudo bash

ollama: $(ollama_bin)

ollama-pull-llama3:
	$(call header,Ollama - Configure)
	ollama pull llama3.1

ollama-uninstall:
	$(call header,Ollama - Uninstall)
	sudo systemctl stop ollama
	sudo systemctl disable ollama
	sudo rm /etc/systemd/system/ollama.service
	sudo rm $$(which ollama)
	sudo userdel ollama
	sudo groupdel ollama
