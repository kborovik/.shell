.ONESHELL:
.SILENT:
.EXPORT_ALL_VARIABLES:

###############################################################################
# Variables
###############################################################################
checkov_args := --soft-fail --enable-secret-scan-all-files --compact --deep-analysis --directory .

###############################################################################
# Targets
###############################################################################
checkov:
	$(call header, Run Checkov with baseline)
	checkov --baseline .checkov.baseline ${checkov_args}

checkov-all:
	$(call header, Run Checkov NO baseline)
	checkov --quiet ${checkov_args}

checkov-baseline:
	$(call header, Create Checkov baseline)
	checkov --quiet --create-baseline ${checkov_args}

checkov-update checkov-install:
	pip install -U checkov

###############################################################################
# Functions
###############################################################################
define header
echo
echo "########################################################################"
echo "# $(1)"
echo "########################################################################"
endef

###############################################################################
# Errors
###############################################################################
ifeq ($(shell which pip),)
$(error ==> Missing PIP https://pypi.org/project/pip/ <==)
endif
