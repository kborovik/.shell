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

include functions.mk

ifeq ($(OS),Linux)
include Linux.mk
else ifeq ($(OS),Darwin)
include Darwin.mk
else
$(error ==> Unsupported OS: $(OS) <==)
endif

settings:
	$(call header,System)
	$(call var,OS,$(OS))
	$(call var,CPU,$(CPU))
	$(call var,SHELL,$(SHELL))
	$(call var,MAKE,$(make_version))

###############################################################################
# Repo Version
###############################################################################

.PHONE: version commit tag release

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

ifneq ($(make_version),4)
$(error ==> GNU Make 4.x is required <==)
endif
