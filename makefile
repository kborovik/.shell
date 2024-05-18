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
	$(call help,make install,Install and configure)

settings:
	$(call header,System)
	$(call var,OS,$(OS))
	$(call var,CPU,$(CPU))
	$(call var,SHELL,$(SHELL))
	$(call var,MAKE,$(make_version))

###############################################################################
# Git: Distributed version control system
###############################################################################

git-version:
	$(call header,Git - Version)
	git --version

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
###############################################################################

ifeq ($(OS),Linux)
atuin_bin := /usr/bin/atuin
else ifeq ($(OS),Darwin)
atuin_bin := /opt/homebrew/bin/atuin
else
$(error ==> Unsupported OS: $(OS) <==)
endif

atuin_config := .config/atuin/config.toml

atuin: atuin-install atuin-configure atuin-version

atuin-install: $(atuin_bin)

$(atuin_bin):
	$(call header,Atuin - Install)
	curl -sSf https://setup.atuin.sh | bash

atuin-configure:
	$(call header,Atuin - Configure)
	ln -fs $(PWD)/$(atuin_config) $(HOME)/$(atuin_config)

atuin-version:
	$(call header,Atuin - Version)
	atuin status

###############################################################################
# Colors and Headers
###############################################################################

black := \033[30m
red := \033[31m
green := \033[32m
yellow := \033[33m
blue := \033[34m
magenta := \033[35m
cyan := \033[36m
white := \033[37m
reset := \033[0m

define header
echo "$(blue)==> $(1) <==$(reset)"
endef

define help
echo "$(green)$(1)$(reset) - $(white)$(2)$(reset)"
endef

define var
echo "$(magenta)$(1)$(reset): $(yellow)$(2)$(reset)"
endef

prompt:
	echo -n "$(blue)Continue?$(reset) $(yellow)(yes/no)$(reset)"
	read -p ": " answer && [ "$$answer" = "yes" ] || exit 1

###############################################################################
# Repo Version
###############################################################################

.PHONY: version

version:
	version=$$(date +%Y.%m.%d-%H%M)
	echo "$$version" >| VERSION
	$(call header,Version: $$(cat VERSION))
	git add VERSION

commit: version
	git add --all
	git commit -m "$$(cat VERSION)"

tag: commit
	version=$$(date +%Y.%m.%d)
	git tag "$$version" -m "Version: $$version"

release: tag
	git push --tags --force

###############################################################################
# Errors check
###############################################################################

# ifneq ($(make_version),4)
# $(error ==> GNU Make 4.x is required <==)
# endif
