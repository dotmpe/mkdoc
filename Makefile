# Non-recursive makefile
# Example of mkdoc usage, see git://github.org/dotmpe/mkdoc

BUILD               := .build/
DIR                 := .

MK_ROOT             := ~/project/mkdoc/
MK_SHARE            := $(MK_ROOT)usr/share/mkdoc/

ifneq ($(VERBOSE), )
$(info mkdocs:DIR=$(DIR))
$(info mkdocs:BUILD=$(BUILD))
$(info mkdocs:MK_ROOT=$(MK_ROOT))
$(info mkdocs:MK_SHARE=$(MK_SHARE))
endif

include                $(MK_SHARE)Core/Main.mk

$(info $(shell $(ll) attention "mkdoc" "Core script loaded, reading shares" ))

include                \
                       $(MK_SHARE)docutils/Main.mk \
                       $(MK_SHARE)bookmarklet/Main.mk \
                       $(MK_SHARE)tidy/Main.mk \
                       $(MK_SHARE)graphviz/Main.mk 

MK                  += $(DIR)/Makefile

$(info $(shell $(ll) attention "mkdoc" "Reading shared default rules" ))

include                \
					   $(MK_SHARE)bookmarklet/Rules.default.mk \
                       $(MK_SHARE)graphviz/Rules.mk \
                       $(MK_SHARE)rubber/Rules.default.mk \
					   $(MK_SHARE)docutils/Rules.default.mk \
					   $(MK_SHARE)plotutils/Rules.default.mk \
#					   $(MK_SHARE)Core/Rules.archive.mk

$(info $(shell $(ll) attention "mkdoc" "Reading local rules" ))

# Include specific rules and set SRC, DEP, TRGT and CLN variables.
include                $(call rules,$(DIR)/) 

$(info $(shell $(ll) attention "mkdoc" "Reading standard rules" ))

# Now set some standard targets
include                $(MK_SHARE)Core/Rules.default.mk

$(info $(shell $(ll) OK "mkdoc" "Starting $(MAKECMDGOALS).." ))

