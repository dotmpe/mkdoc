# Non-recursive makefile

# Id: mkdoc/0.0.2-devel Mkdocs-full.mk


# CURDIR and MAKEFILE_LIST are GNU Make internals
location             = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

# Global list of all makefiles
MK                  := $(location)
#MK                  += $(DIR)/Makefile

# Set level to warning and above
VERBOSE             ?= 4
ifneq ($(V), )
VERBOSE             := $(V)
endif

PREFIX              ?= $(CURDIR)/usr/
MK_SHARE            ?= $(PREFIX)/share/mkdoc/
#MK_CONF             := /etc/mkdoc/ $(HOME)/.mkdoc/
MK_BUILD            ?= /var/mkdoc/

PROJECT             := mkdoc
DOMAIN              ?= mpe

# fixme: rewrite to MK_BUILD
BUILD               ?= .build/

# Start keeping present directory
DIR                 := .
#DIR                 := $(CURDIR)

#      ------------ -- 

d                   := $(DIR)
MK_$d               := Mkdocs-full

#      ------------ -- 

ifeq ($(MAKECMDGOALS),info)
$(info Heads up, running 'make info V=$(VERBOSE)', use lower values for less info. )
endif

include                $(MK_SHARE)Core/Main.mk

ifeq ($(MAKECMDGOALS),info)
$(info $(shell $(ll) info info "OK loaded $(MK_SHARE)Core/Main.mk"))
endif
$(call chat,header,mkdoc,Core script loaded)

# Check wether this filename (target of the Makefile symlink) corresponds to MK_$d
ifneq ($(shell [ -L "$(MK)" ] && basename $$(readlink $(MK)) .mk),$(MK_$d))
$(call chat,warn,mkdoc,Do not link Makefile but rather $(MK_$d))
endif

#      ------------ -- 

# log-line script is now available for pretty print, do some chatter now:
$(call chat,info,$(MK_$d),Chattiness set to $(VERBOSE))
$(call chat,debug,$(MK_$d),DIR=$(DIR))
$(call chat,debug,$(MK_$d),BUILD=$(BUILD))
$(call chat,debug,$(MK_$d),MK_SHARE=$(MK_SHARE))
$(call chat,debug,$(MK_$d),MK_BUILD=$(MK_BUILD))

#      ------------ -- 

$(call chat,debug,mkdoc,Reading package main include files)

include                \
                       $(MK_SHARE)markdown/Main.mk \
                       $(MK_SHARE)docutils/Main.mk \
                       $(MK_SHARE)bookmarklet/Main.mk \
                       $(MK_SHARE)vc/Main.mk \
                       $(MK_SHARE)tidy/Main.mk \
                       $(MK_SHARE)haxe/Main.mk \
                       $(MK_SHARE)plotutils/Main.mk \
                       $(MK_SHARE)graphviz/Main.mk \
                       $(MK_SHARE)python/Main.mk

$(call chat,debug,mkdoc,Done loading packages main file)
$(call chat,debug,mkdoc)

#      ------------ -- 

$(call chat,header,mkdoc,Reading default rules from packages)

#
include                \
                       $(MK_SHARE)bookmarklet/Rules.default.mk \
                       $(MK_SHARE)graphviz/Rules.default.mk \
                       $(MK_SHARE)rubber/Rules.default.mk \
                       $(MK_SHARE)markdown/Rules.default.mk \
                       $(MK_SHARE)docutils/Rules.default.mk \
                       $(MK_SHARE)haxe/Rules.default.mk \
                       $(MK_SHARE)plotutils/Rules.default.mk \
                       $(MK_SHARE)python/Rules.default.mk
#					   $(MK_SHARE)Core/Rules.archive.mk

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
