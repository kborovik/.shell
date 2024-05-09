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

###############################################################################
# Repo Version
###############################################################################

.PHONY: version

version:
	echo $$(date +%Y.%m.%d-%H%M) >| VERSION
	git add VERSION
	echo "VERSION: $$(cat VERSION)"

commit: version
	git add --all
	git commit -m "$$(cat VERSION)"

tag:
	release_ver=$$(date +%Y.%m.%d)
	git tag $${release_ver} -m "$${release_ver}"

release: tag

###############################################################################
# Errors check
###############################################################################

# ifneq ($(make_version),4)
# $(error ==> GNU Make 4.x is required <==)
# endif
