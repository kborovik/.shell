.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

###############################################################################
# Default target
###############################################################################

default: posh bash vim mods

###############################################################################
# Bash: The GNU Bourne Again SHell
###############################################################################

bash: bash-install bash-configure

bash_completion := $(HOME)/.local/share/bash-completion

$(bash_completion):
	$(call header,Creating Bash directories)
	mkdir -p $(@)

bash-install:
	$(call header,Installing Bash)
	brew install bash bash-completion@2 coreutils git pass pipx scc tree wget fx jq yq openssl@3

bash-configure: $(bash-dirs)
	$(call header,Configure Bash)
	ln -v -s -r -f .profile $(HOME)/.profile
	ln -v -s -r -f .bashrc $(HOME)/.bashrc
	ln -v -s -r -f bash-completion/completions $(bash_completion)
	ln -v -s -r -f .digrc $(HOME)/.digrc

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
	ln -v -s -r -f .vimrc $(HOME)/.vimrc
	ln -v -s -r -f .vim $(HOME)

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
	ln -v -s -r -f mods.yml $(mods_config)

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
