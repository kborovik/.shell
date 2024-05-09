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

include functions.mk

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
# Errors check
###############################################################################

# ifneq ($(make_version),4)
# $(error ==> GNU Make 4.x is required <==)
# endif
