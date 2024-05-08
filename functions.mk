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
echo "$(green)==> $(1) <==$(reset)"
endef

define help
echo "$(blue)$(1)$(reset) - $(white)$(2)$(reset)"
endef

define var
echo "$(magenta)$(1)$(reset): $(yellow)$(2)$(reset)"
endef

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
