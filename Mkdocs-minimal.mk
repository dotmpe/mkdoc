# Non-recursive makefile


BUILD               := .build/
DIR                 := .

# Set level to warning and above
VERBOSE             ?= 4
ifneq ($(V), )
VERBOSE             := $(V)
endif

PREFIX             ?= $(CURDIR)/usr/
MK_SHARE           ?= $(PREFIX)/share/mkdoc/

ifneq ($(DEBUG), )
$(info mkdocs:DIR=$(DIR))
$(info mkdocs:BUILD=$(BUILD))
$(info mkdocs:MK_SHARE=$(MK_SHARE))
endif

#      ------------ -- 

include                $(MK_SHARE)Core/Main.mk

$(call chat,header,mkdoc,"Core script loaded, reading shares")

#include                \
                       $(MK_SHARE)<package_name>/Main.mk \

#      ------------ -- 

MK                  += $(DIR)/Makefile

$(call chat,header,mkdoc,Reading default rules from packages)

#include                \
                       $(MK_SHARE)<package_name>/Rules.default.mk \

$(call chat,debug,mkdoc,Done loading packages rules files)
$(call chat,debug,mkdoc)

#      ------------ -- 

$(call chat,header,mkdoc,Reading local rules)

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
