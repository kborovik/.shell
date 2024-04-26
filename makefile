.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

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

settings:
	$(info ==> System Settings <==)
	$(info OS: $(OS))
	$(info CPU: $(CPU))
	$(info SHELL: $(SHELL))
	$(info MAKE: $(make_version))
	$(info PATH: $(PATH))

###############################################################################
# Errors check
###############################################################################

ifneq ($(make_version),4)
$(error ==> GNU Make 4.x is required <==)
endif
