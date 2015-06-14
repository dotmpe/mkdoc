# Non-recursive makefile


BUILD               := .build/
DIR                 := $(CURDIR)

PREFIX             ?= /usr/local
MK_SHARE           ?= $(PREFIX)/share/mkdoc/

ifneq ($(VERBOSE), )
$(info mkdocs:DIR=$(DIR))
$(info mkdocs:BUILD=$(BUILD))
$(info mkdocs:MK_SHARE=$(MK_SHARE))
endif

#      ------------ -- 

include                $(MK_SHARE)Core/Main.mk
ifneq ($(VERBOSE), )
$(info $(shell $(ll) header "mkdoc" "Core script loaded, reading shares" ))
endif

#include                \
                       $(MK_SHARE)<package_name>/Main.mk \

#      ------------ -- 

MK                  += $(DIR)/Makefile

ifneq ($(VERBOSE), )
$(info $(shell $(ll) header "mkdoc" "Reading shared default rules" ))
endif

#include                \
                       $(MK_SHARE)<package_name>/Rules.default.mk \

#      ------------ -- 

ifneq ($(VERBOSE), )
$(info $(shell $(ll) header "mkdoc" "Reading local rules" ))
endif

# Include specific rules and set SRC, DEP, TRGT and CLN variables.
#
include                $(call rules,$(DIR)/) 

#      ------------ -- 

ifneq ($(VERBOSE), )
$(info $(shell $(ll) header "mkdoc" "Reading standard rules" ))
endif

# Now set some standard targets
#
include                $(MK_SHARE)Core/Rules.default.mk

#      ------------ -- 

$(info $(shell $(ll) OK "mkdoc" "starting 'make $(MAKECMDGOALS)'.." ))
# vim:ft=make:
