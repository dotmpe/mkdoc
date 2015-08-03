
# Id: mkdoc/0.0.2-test Makefile

BUILD               := .build/
# some variants on CURDIR:
DIR                 := .
BASE                := $(shell cd $(DIR);pwd)

HOST                := $(shell hostname -s | tr 'A-Z' 'a-z' | tr '.' '-')
ENV                 ?= $(shell [ -n "$$ENV" ] && echo $$ENV || echo development)

#ID                  := mkdoc/0.0.1-master
PROJECT             := mkdoc
VERSION             := 0.0.2-test# mkdoc


# CURDIR and MAKEFILE_LIST are GNU Make internals
location             = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

# Global list of all makefiles
MK                  := $(location)
#MK                  += $(DIR)/Makefile

BASE                := $(shell cd $(DIR);pwd)
relative = $(patsubst $(BASE)%,$(PROJECT):%,$1)
where-am-i = $(call relative,$(lastword $(MAKEFILE_LIST)))

# BSD weirdness
echo = /bin/echo

#      ------------ --

## Make internals

# make include search path
VPATH              := . /

# make shell
SHELL              := /bin/bash

# reset file extensions
# xxx for imlicit rules?
.SUFFIXES:
#.SUFFIXES:         .rst .js .xhtml .mk .tex .pdf .list
.SUFFIXES: .rst .mk

#      ------------ --

## Local setup

# name default target, dont set deps yet
default::

# preset DEFAULT based on environment/goals
include Makefile.default-goals

# global path/file lists
SRC                :=
DMK                :=
#already setMK                 :=
DEP                :=
TRGT               :=
STRGT              := default usage stat build test install check clean info 
CLN                :=
TEST               :=
INSTALL            :=


# rules: return Rules files for each directory in $1
RULE_PREFIX := ./ .
rules = $(foreach D,$1,\
	$(foreach P,$(RULE_PREFIX), \
			$(wildcard \
				$D$PRules.mk \
				$D$PRules.shared.mk $D$PRules.*.shared.mk \
				$D$PRules.$(PROJECT).mk \
				$D$PRules.$(HOST).mk \
	)))

# Include all local rules files
#
include                $(call rules,$(DIR)/)

# pseudo targets are not files, don't check with OS
.PHONY: $(STRGT)

DEFAULT ?= usage

#      ------------ --

## Main rules/deps

default:: $(DMK) $(DEP)
default:: $(DEFAULT)

usage::
	@echo 'set ENV to [development|testing|production] for other default behaviour'

stat:: $(SRC)

build:: $(TRGT)

test:: $(TEST)

install:: $(INSTALL)

check::

clean:: .
	rm -rf $(CLN)

info::
	@echo "Id: $(PROJECT)/$(VERSION)"
	@echo "Name: $(PROJECT)"
	@echo "Version: $(VERSION)"

