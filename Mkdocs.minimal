# Non-recursive makefile
# Example of mkdoc usage, see git://github.org/dotmpe/mkdoc

# Set level to warning and above
VERBOSE             ?= 4
ifneq ($(V), )
VERBOSE             := $(V)
endif

BUILD               := .build/
DIR                 := .

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

# Now at last set standard targets and prerequisites
#
include                $(MK_SHARE)Core/Rules.default.mk

#      ------------ -- 

$(info $(shell $(ll) OK "mkdoc" "starting 'make $(MAKECMDGOALS)'.." ))

# vim:ft=make:
