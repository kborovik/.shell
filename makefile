.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:

MAKEFLAGS += --no-builtin-rules --no-builtin-variables

default: settings help

###############################################################################
# Settings
###############################################################################

CPU := $(shell uname -m)
OS := $(shell uname -s)

make_version := $(shell $(MAKE) --version | grep "GNU Make" | cut -d ' ' -f 3 | cut -d '.' -f 1)

ifeq ($(OS),Linux)
include Linux.mk
else ifeq ($(OS),Darwin)
include Darwin.mk
else
$(error ==> Unsupported OS: $(OS) <==)
endif

help:
	$(call header,Help)
	$(call help,make core-tools,Install and configure OS Core Tools)

settings:
	$(call header,System)
	$(call var,OS,$(OS))
	$(call var,CPU,$(CPU))
	$(call var,SHELL,$(SHELL))
	$(call var,MAKE,$(make_version))

###############################################################################
# Git: Distributed version control system
###############################################################################

git-credentials-load:
	$(call header,Git - Load credentials)
	pass git pull
	pass kborovik/git/credentials >| ~/.git-credentials

git-credentials-save:
	$(call header,Git - Save credentials)
	pass git pull
	pass insert -m -f kborovik/git/credentials < ~/.git-credentials
	pass git push

###############################################################################
# atuin: A command-line tool for managing your dotfiles
# Ubuntu: ZFS work around
# vim /etc/fstab
# /dev/zd0 /home/kb/.local/share/atuin ext4 x-systemd.after=systemd-user-sessions.service 0 2
###############################################################################

ifeq ($(OS),Linux)
atuin_bin := /usr/bin/atuin
else ifeq ($(OS),Darwin)
atuin_bin := /opt/homebrew/bin/atuin
else
$(error ==> Unsupported OS: $(OS) <==)
endif

atuin_config := .config/atuin/config.toml

$(atuin_bin):
	$(call header,Atuin - Install)
	curl -sSf https://setup.atuin.sh | bash

atuin: $(atuin_bin)
	ln -fs $(PWD)/$(atuin_config) $(HOME)/$(atuin_config)

###############################################################################
# Colors and Headers
###############################################################################

TERM := xterm-256color

black := $$(tput setaf 0)
red := $$(tput setaf 1)
green := $$(tput setaf 2)
yellow := $$(tput setaf 3)
blue := $$(tput setaf 4)
magenta := $$(tput setaf 5)
cyan := $$(tput setaf 6)
white := $$(tput setaf 7)
reset := $$(tput sgr0)

define header
echo "$(blue)==> $(1) <==$(reset)"
endef

define help
echo "$(green)$(1)$(yellow) - $(white)$(2)$(reset)"
endef

define var
echo "$(magenta)$(1)$(white): $(yellow)$(2)$(reset)"
endef

prompt:
	echo -n "$(magenta)Continue? $(cyan)(yes/no)$(reset)"
	read -p ": " answer && [ "$$answer" = "yes" ] || exit 1

###############################################################################
# Repo Version
###############################################################################

.PHONY: version

version:
	version=$$(date +%Y.%m.%d-%H%M)
	echo "$$version" >| VERSION
	$(call header,Version: $$(cat VERSION))
	git add --all

commit: version
	git commit -m "$$(cat VERSION)"

