.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

###############################################################################
# Default target
###############################################################################

default:

###############################################################################
# Mods: AI for the command line, built for pipelines.
# https://github.com/charmbracelet/mods
###############################################################################

mods_config := "$(HOME)/Library/Application Support/mods/mods.yml"

mods: mods-install mods-configure mods-status

mods-install: $(charm_gpg_key) $(charm_apt_repo)
	$(info ==> Installing Mods <==) 
	brew install mods

mods-configure:
	$(info ==> Configure Mods <==)
	ln -v -s -r -f mods.yml $(mods_config)

mods-uninstall:
	$(info ==> Uninstalling Mods <==)
	brew rm mods

mods-status:
	$(info ==> Checking Mods status <==)
	mods --version

###############################################################################
# Ollama: A CLI for the Ollama API
# https://ollama.com/download/linux
###############################################################################

ollama: ollama-install

ollama-install:
	$(info ==> Downloading Ollama installation to $(HOME)/Downloads/ <==)
	curl -fsSl https://ollama.com/download/Ollama-darwin.zip -o $(HOME)/Downloads/Ollama-darwin.zip

ollama-configure:
	$(info ==> Configure Ollama <==)
	ollama pull llama3
	ollama pull llama3:8b-instruct-q8_0

ollama-uninstall:
	$(info ==> Uninstalling Ollama <==)

ollama-status:
	$(info ==> Checking Ollama status <==)
	ollama --version
