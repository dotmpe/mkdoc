# Non-recursive makefile
# Example of mkdoc usage, see git://github.org/dotmpe/mkdoc

MK_ROOT             := ~/project/mkdoc/
MK_SHARE            := $(MK_ROOT)usr/share/mkdoc/

include                $(MK_SHARE)Core/Main.mk \
                       $(MK_SHARE)docutils/Main.mk \
                       $(MK_SHARE)bookmarklet/Main.mk 

DIR                 := .
ROOT                := $(realpath .)
BUILD               := $(DIR)/.build/

MK                  += $(DIR)/Makefile

include                $(MK_SHARE)docutils/Rules.default.mk

# Include specific rules and set SRC, DEP, TRGT and CLN variables.
include                $(call rules,$(DIR)) 

# Now set some standard targets
include                $(MK_SHARE)Core/Rules.default.mk

