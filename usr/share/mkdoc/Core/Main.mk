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

VPATH              += /
SHELL              := /bin/bash

#.SUFFIXES:         .rst .js .xhtml .mk .tex .pdf .list
#.SUFFIXES:         .rst .js .xhtml .mk .tex .pdf .list


MK_ROOT            := ~/project/mkdoc/
MK_SHARE           := $(MK_ROOT)usr/share/mkdoc/
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


ll                  = $(MK_SHARE)Core/log.sh
ee                  = /bin/echo -e
mk-subdir-rules     =
mk-target-dir       = if test ! -d $(@D); then mkdir -p $(@D); fi
complement          =

define mk-target
	$(mk-target-dir)
	if test ! -f $@; then touch $@; fi
endef

define reset-target
	$(mk-target-dir)
	if test -f $@; then rm $@; fi
	touch $@
endef

define mk-include
	$(reset-target)
	for f in MK_FILES; do \
		echo DIR=`dirname $$f` >> $@; \
		echo include $$f >> $@; \
	done
endef

log                 = $(ll) "$1" "$2" "$3" "$4"
count               = $(shell if test -n "$1"; then\
					    echo $1|wc -w; else echo 0; fi;)

default:               

