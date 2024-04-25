.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

###############################################################################
# TUI Library and Apps
# https://github.com/charmbracelet
###############################################################################

charm_gpg_key := /etc/apt/trusted.gpg.d/charm.gpg
charm_apt_repo := /etc/apt/sources.list.d/charm.list

$(charm_gpg_key):
	$(info ==> Installing Charm GPG key <==)
	curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o $@

$(charm_apt_repo):
	$(info ==> Adding Charm APT repository <==)
	echo "deb [signed-by=$(charm_gpg_key)] https://repo.charm.sh/apt/ * *" | sudo tee $@

###############################################################################
# Mods: AI for the command line, built for pipelines.
# https://github.com/charmbracelet/mods
###############################################################################

mods-install: $(charm_gpg_key) $(charm_apt_repo)
	$(info ==> Installing Mods <==) 
	sudo apt update && sudo apt install mods

mods-configure:
	$(info ==> Configure Mods <==)
	cp mods.yml /home/kb/.config/mods/

mods-uninstall:
	$(info ==> Uninstalling Mods <==)
	sudo apt remove mods

mods-status:
	$(info ==> Checking Mods status <==)
	apt list --verbose mods

###############################################################################
# Glow: Render markdown on the CLI
# https://github.com/charmbracelet/glow
###############################################################################

glow-install: $(charm_gpg_key) $(charm_apt_repo)
	$(info ==> Installing glow <==) 
	sudo apt update && sudo apt install glow

glow-uninstall:
	$(info ==> Uninstalling glow <==)
	sudo apt remove glow

glow-status:
	$(info ==> Checking glow status <==)
	apt list --verbose glow

###############################################################################
# Ollama: A CLI for the Ollama API
# https://ollama.com/download/linux
###############################################################################

ollama-install:
	$(info ==> Installing Ollama <==)
	curl -fsSL https://ollama.com/download/linux | sudo bash

ollama-configure:
	$(info ==> Configure Ollama <==)
	ollama pull llama3

ollama-uninstall:
	$(info ==> Uninstalling Ollama <==)
	sudo systemctl stop ollama
	sudo systemctl disable ollama
	sudo rm /etc/systemd/system/ollama.service
	sudo rm $(which ollama)
	sudo userdel ollama
	sudo groupdel ollama

ollama-status:
	$(info ==> Checking Ollama status <==)
	ollama --version
