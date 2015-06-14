# Non-recursive makefile


BUILD               := .build/
DIR                 := $(CURDIR)


# CURDIR and MAKEFILE_LIST are GNU Make internals
location             = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

# Global list of all makefiles
MK                  := $(location)
#MK                  += $(DIR)/Makefile

PREFIX             ?= /usr/local
MK_SHARE           ?= $(PREFIX)/share/mkdoc/

ifneq ($(VERBOSE), )
$(info mkdocs:DIR=$(DIR))
$(info mkdocs:BUILD=$(BUILD))
$(info mkdocs:MK_SHARE=$(MK_SHARE))
endif

#      ------------ -- 

include                $(MK_SHARE)Core/Main.mk

$(call chat,header,mkdoc,Core script loaded, reading shares)

include                \
                       $(MK_SHARE)docutils/Main.mk \
                       $(MK_SHARE)bookmarklet/Main.mk \
                       $(MK_SHARE)vc/Main.mk \
                       $(MK_SHARE)tidy/Main.mk \
                       $(MK_SHARE)graphviz/Main.mk 

#      ------------ -- 

MK                  += $(DIR)/Makefile

$(call chat,header,mkdoc,Reading default rules from packages)

include                \
                       $(MK_SHARE)bookmarklet/Rules.default.mk \
                       $(MK_SHARE)graphviz/Rules.mk \
                       $(MK_SHARE)rubber/Rules.default.mk \
                       $(MK_SHARE)docutils/Rules.default.mk \
                       $(MK_SHARE)plotutils/Rules.default.mk \
#					   $(MK_SHARE)Core/Rules.archive.mk

#      ------------ -- 

ifneq ($(VERBOSE), )
$(info $(shell $(ll) header "mkdoc" "Reading local rules" ))
endif

# Include specific rules and set SRC, DEP, TRGT and CLN variables.
#
include                $(call rules,$(DIR)/) 

#      ------------ -- 

$(call chat,header,mkdoc,Reading standard rules)

# Now set some standard targets
#
include                $(MK_SHARE)Core/Rules.default.mk

#      ------------ -- 

$(call chat,debug,mkdoc)
$(call chat,OK,mkdoc,starting 'make $(MAKECMDGOALS)')
$(call chat,debug,mkdoc)

# vim:ft=make:
