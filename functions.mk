###############################################################################
# Colors and Headers
###############################################################################

black := \e[30m
red := \e[31m
green := \e[32m
yellow := \e[33m
blue := \e[34m
magenta := \e[35m
cyan := \e[36m
white := \e[37m
reset := \e[0m

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
