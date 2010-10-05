### MkDocs Core Makefile
# :Date: 2010-10-04
# :Author: B. van Berkum  <dev@dotmpe.com>
#
# This is a non-recursive makefile,
# see Rules.mk for each directory.
#
# To use MkDoc, include this file in your projects main Makefile first.
# Finally, include some standard rules or set these yourself. See:
# $(MK_SHARE)Core/Rules.default.mk

VPATH              += . / 
SHELL              := /bin/bash

.SUFFIXES:         .rst .js .xhtml .mk .tex .pdf .list

MK_ROOT            := ~/project/mkdoc/
MK_SHARE           := $(MK_ROOT)usr/share/mkdoc/

BUILD              := .build/

HOST               := $(shell hostname)
ifndef ROOT
ROOT               := $(shell pwd)
endif


SRC                :=
DMK                :=
MK                 :=
DEP                :=
TRGT               :=
STRGT              := 
CLN                :=
TEST               :=
INSTALL            :=
MISSING            :=  
OFFLINE            :=


ll                  = $(MK_SHARE)Core/log.sh
ee                  = /bin/echo -e
mk-target-dir       = if test ! -d $(@D); then mkdir -p $(@D); fi


define mk-target
	$(mk-target-dir)
	if test ! -f "$@"; then touch $@; fi
endef

define reset-target
	$(mk-target-dir)
	if test -f "$@"; then rm $@; fi
	touch $@
endef

define mk-include
	$(reset-target)
	for f in $(MK_FILES); do \
		echo "ifeq (\$$(realpath $$f 2>/dev/null),)" >> $@; \
		echo "MISSING += $$f" >> $@; \
		echo "else" >> $@; \
		echo "DIR=`dirname $$f`" >> $@; \
		echo "include $$f" >> $@; \
		echo "endif" >> $@; \
	done;
endef

log                 = $(ll) "$1" "$2" "$3" "$4"
count               = $(shell if test -n "$1"; then\
					    echo $1|wc -w; else echo 0; fi;)
contains            = for Z in "$1"; do if test "$$Z" = "$2"; then \
					    echo "$$Z"; fi; done;
expand-path         = $(shell echo $1)
rules               = $(shell for D in $1; do \
                        if test -f "$$(echo $$D/Rules.mk)"; then \
                          echo $$D/Rules.mk; else \
                        if test -f "$$(echo $$D/.Rules.mk)"; then \
						  echo $$D/.Rules.mk; else \
                        if test -f "$$(echo $$D/Rules.$(HOST).mk)"; then \
                          echo $$D/Rules.$(HOST).mk; else \
                        if test -f "$$(echo $$D/.Rules.$(HOST).mk)"; then \
						  echo $$D/.Rules.$(HOST).mk; else \
						  echo $$D/Rules.mk; fi; fi; fi; fi; done )
sub-rules           = $(foreach V,$1,$(call rules,"$V/*"))
filter-dir          = $(shell for D in $1; do if test -d "$$D"; then \
                        echo $$D; fi; done)
filter-file         = $(shell for F in $1; do if test -f "$$F"; then \
                        echo $$F; fi; done)
complement          = $(shell \
					    for X in $1; do \
					      if test -z "$$(for Z in $2; do if test "$$Z" = "$$X"; \
					        then echo $$X; fi; done)"; then \
					        echo "$$X"; fi; done; )


default:               

