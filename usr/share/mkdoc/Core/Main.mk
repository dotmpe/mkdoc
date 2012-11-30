### MkDocs Core Makefile
# :Date: 2010-10-04
# :Last Update: 2012-03-09
# :Author: B. van Berkum  <dev@dotmpe.com>
#
# This is a non-recursive makefile,
# see Rules.mk for each directory.
#
# To use MkDoc, include this file in your projects main Makefile first.
# Finally, include some standard rules or set these yourself. See:
# $(MK_SHARE)Core/Rules.default.mk



###    make configuration
#      ------------ -- 
VPATH               := . /
SHELL               := /bin/bash

.SUFFIXES:
.SUFFIXES:             .rst .js .xhtml .mk .tex .pdf .list


###    MkDoc globals
#      ------------ -- 

## Environment
# FIXME: merge: global vars:
#SRC_PATH            := /src/
#PROJ_PATH           := /srv/project-$(DOMAIN)/
#MK_ROOT             := $(PROJ_PATH)mkdoc/
#MK_SHARE            := $(MK_ROOT)usr/share/mkdoc/
HOST                := $(shell hostname -s | tr 'A-Z' 'a-z')
ifndef ROOT
ROOT                := $(shell pwd)
endif
OS                  := $(shell uname)

VERBOSE             ?= $(V)

## Dict of installed cmd utils
BIN                 := \
	bash=$(shell which bash)

## Path and file lists
SRC                 :=
DMK                 :=
#already setMK                 :=
DEP                 :=
CLN                 :=
TEST                :=
INSTALL             :=

## Special and file build target lists (to build)
TRGT                :=
STRGT               :=

## Non-informal target messages (after build)
PENDING             :=
MISSING             :=
OFFLINE             :=

# TODO: list domain/net paths
RES                 :=


###    Standard targets
#      ------------ -- 
# (append to STRGT) see Rules.default.mk
STDTRGT             := \
					   all dep dmk test build install clean cleandep
STDSTAT             := \
					   help stat list lists info

## Dict with special target descriptions 
DESCRIPTION         := all='build, test and install'
DESCRIPTION         += dep='generate dependencies'
DESCRIPTION         += dmk='generate dynamic makefiles'
DESCRIPTION         += test='TODO: run tests'
DESCRIPTION         += build='builds all targets'
DESCRIPTION         += install='TODO (no-op)'
DESCRIPTION         += clean='delete all targets'
DESCRIPTION         += cleandep='delete all dynamic makefiles and dependencies'

DESCRIPTION         += help='print this help'
DESCRIPTION         += stat='assert sources, dynamic makefiles and other dependencies'
DESCRIPTION         += list='print SRC and TRGT lists'
DESCRIPTION         += lists='print all other lists'
DESCRIPTION         += info='print other metadata'


###    Various snippets
#      ------------ -- 

# log-line:  1.LINETYPE  2.TARGETS  3.MESSAGE  4.SOURCES
ll                  = $(MK_SHARE)Core/log.sh
# see log-* functions

ifeq ("$(OS)","Darwin")
ee                  = /bin/echo
else
ee                  = /bin/echo -e
endif

sed-trim            = sed 's/^ *//g' | sed 's/ *$$//g'
sed-escape          = awk '{gsub("[~/:.]", "\\\\&");print}'
filter-paths        = grep -v ^\# | grep -v ^\s*$$
trim-paths          = sed 's/\/\//\//g' | sed 's/\.\///g'
getpaths            = cat "$$F" | $(filter-paths)
count-lines         = wc -l "$$F" | sed 's/^\ *\([0-9]*\).*$$/\1/g'


###    Functions
#      ------------ -- 

require-bin              = ( V=$1; declare $(BIN); \
	while [ -n "$${!V}" ] ; do V="$${!V}"; done; [ "$$V" != "$1" ] \
	&& echo $$V || exit 1 )
get-bin              = ( V=$1; declare $(BIN); \
	while [ -n "$${!V}" ] ; do V="$${!V}"; done; [ "$$V" != "$1" ] && echo $$V )

echo-if-true        = $(shell [ $1 ] && echo true)
key                 = $(shell declare $($1); echo "$$$2")
#key                 = $(shell declare $($1); [ -z "$$$2" ] && ( echo missing $2; exit 1) || (echo $$$2))
define require-key
$(if $(call key,$1,$2),,$(error $(shell $(ll) "error" mkdocs "Missing key $2 for $1")))
endef
# complement: return items from $1 not in $2
complement          = $(shell \
					    for X in $1; do \
					      if test -z "$$(for Z in $2; do if test "$$Z" = "$$X"; \
					        then echo $$X; fi; done)"; then \
					        echo "$$X"; fi; done; )
has-duplicates      = $(filter $(words $1), $(words $(sort $1)))
paths-exist         = $(filter $(wildcard $1),$1)
not-exist           = $(call complement,$1,$(call paths-exist,$1))

init-dir            = if test ! -d $1; then mkdir -p $1; fi
init-file           = if test ! -f $1; then mkdir -p $$(dirname $1); touch $1; fi
count               = $(shell if test -n "$1"; then\
					    echo $1|wc -w|sed 's/ //g'; else echo 0; fi;)
count-list          = $(shell if test -f "$1"; then\
					    cat $1|wc -l; else echo 0; fi;)
f-count-lines       = $(shell F=$1; $(count-lines))
contains            = for Z in "$1"; do if test "$$Z" = "$2"; then \
					    echo "$$Z"; fi; done;
expand-path         = $(shell echo $1)

#exists              = $(shell realpath "$1" 2> /dev/null)
exists              = $(shell [ -e "$1" ] && echo "$1")
is-path             = $(shell if test -e "$1";then echo $1; fi;)
is-file             = $(shell if test -f "$1";then echo $1; fi;)
is-dir              = $(shell if test -d "$1";then echo $1; fi;)
filter-dir          = $(shell for D in $1; do if test -d "$$D"; then \
                        echo $$D; fi; done)
filter-file         = $(shell for F in $1; do if test -f "$$F"; then \
                        echo $$F; fi; done)
clean-plist         = $(sort $(strip $1))
newer-than = $(shell for F in $2; do if test $$F -nt $1; then echo $$F newer than $1; fi; done; )
f-sed-escape          = $(shell echo "$1" | $(sed-escape))
remove-line         = if test -e "$1"; then LINE=$$(echo $2|$(sed-escape));mv "$1" "$1.tmp";cat "$1.tmp"|sed "s/$$LINE//">"$1";rm $1.tmp; else echo "Error: unknown file $1"; fi
assert-line         = if test -z "$$(cat $1|grep $2)";then echo "$2" >> $1; fi;
#parents             = $()
filter-mount        = $(foreach M,$1,$(if $(shell mount|grep $M),$(shell echo $M)))
sub-dirs            = $(abspath $(realpath $(shell \
						for sub in $1/*; do \
						  if test -d "$$sub"; then \
						    echo "$$sub"; fi; done)))
safe-paths          = $(shell D="$(call f-sed-escape,$1)";ls "$1"|grep '^[\/a-zA-Z0-9\+\.,_-]\+$$'|sed "s/^/$$D/g")
unsafe-paths        = $(shell D="$(call f-sed-escape,$1)";ls "$1"|grep -v '^[\/a-zA-Z0-9\+\.,_-]\+$$'|sed "s/^/$$D/g")
# mkid: rewrite filename/path to Make/Bash safe variable ID
mkid                = $(shell echo $1|sed 's/[\/\.,;:_\+-]/_/g')
# rules: return Rules files for each directory in $1
rules               = $(shell for D in $1; do \
                        if test -f "$$(echo $$D/Rules.mk)"; then \
                          echo $$D/Rules.mk; else \
                        if test -f "$$(echo $$D/.Rules.mk)"; then \
						  echo $$D/.Rules.mk; else \
                        if test -f "$$(echo $$D/Rules.$(HOST).mk)"; then \
                          echo $$D/Rules.$(HOST).mk; else \
                        if test -f "$$(echo $$D/.Rules.$(HOST).mk)"; then \
						  echo $$D/.Rules.$(HOST).mk; fi; fi; fi; fi; done )
shared-rules        = $(shell for D in $1; do \
                        if test -f "$$(echo $$D/Rules.shared.mk)"; then \
                          echo $$D/Rules.shared.mk; else \
                        if test -f "$$(echo $$D/.Rules.shared.mk)"; then \
						  echo $$D/.Rules.shared.mk; fi; fi; done )
def-rules           = $(shell for D in $1; do \
                        if test -f "$$(echo $$D/Rules.mk)"; then \
                          echo $$D/Rules.mk; else \
                        if test -f "$$(echo $$D/.Rules.mk)"; then \
						  echo $$D/.Rules.mk; else \
                        if test -f "$$(echo $$D/Rules.$(HOST).mk)"; then \
                          echo $$D/Rules.$(HOST).mk; else \
                        if test -f "$$(echo $$D/.Rules.$(HOST).mk)"; then \
						  echo $$D/.Rules.$(HOST).mk; else \
						  echo $$D/Rules.mk; fi; fi; fi; fi; done )
# sub-rules: return ./*/[.]Rules[.host].mk, ie. rules from subdirs
sub-rules           = $(foreach V,$1,$(call rules,$V/*))
f_getpaths          = $(shell F="$1"; $(getpaths))
zero_exit_test = \
	if test $1 != 0; \
	then \
		$(ll) error "$2" "$4"; \
	else \
		$(ll) OK "$2" "$3"; \
	fi


###    Canned
#      ------------ -- 
init-target         = $(call init-file,$@)
mk-target-dir       = if test ! -d $(@D); then mkdir -p $(@D); fi;
kwds-file           = if test -f "$(KWDS_./$(<D))"; then \
						  echo $(KWDS_./$(<D)); \
						else if test -f "$(KWDS_./$(@D))"; then \
						  echo $(KWDS_./$(@D)); \
						else if test -f "$(KWDS_$(<D))"; then \
						  echo $(KWDS_$(<D)); \
						else if test -f "$(KWDS_$(@D))"; then \
						  echo $(KWDS_$(@D)); \
						else if test -f "$(KWDS_$(DIR))"; then \
						  echo $(KWDS_$(DIR)); \
						else if test -f "$(KWDS_.)"; then \
						  echo $(KWDS_.); \
						else if test -f "$(KWDS)"; then \
						  echo $(KWDS); fi; fi; fi; fi; fi; fi; fi;

define mk-target
	$(mk-target-dir)
	if test ! -f "$@"; then touch $@; fi;
endef

define reset-target
	$(mk-target-dir)
	if test -f "$@"; then rm $@; fi;
	touch $@;
endef

info-target-type = $(ll) info "$@" "`file -bs $@`"
info-target-chars = $(ll) info "$@" "`cat $@|wc -m` chars"
info-target-lines = $(ll) info "$@" "`cat $@|wc -l` lines"
info-text-stat = $(ll) info "$@" "`cat $@|wc -l` lines, `cat $@|wc -m` chars, `file -bs $@` formatted"
info-bin-stat = $(ll) info "$@" "`cat $@|wc -c` bytes, `file -bs $@` format"

define mk-include
	$(reset-target)
	$(error)
	for f in $(MK_FILES); do \
		echo "ifeq (\$$(realpath $$f 2>/dev/null),)" >> $@; \
		echo "MISSING += $$f" >> $@; \
		echo "else" >> $@; \
		echo "DIR := `dirname $$f`" >> $@; \
		echo "include $$f" >> $@; \
		echo "endif" >> $@; \
	done;
endef

#OBmtime=$$(stat --format="%y" "$<");\
#	echo mtime=$$mtime;\
#	FILEMDATETIME=$$(date -r "$$mtime" +"%Y-%m-%d %H:%M:%S %:z");\

define ante-proc-tags
	# Process all source files and expand tag references.
	if test ! -f "$<.src"; then cp $< $<.src; fi
	FILEMDATETIME=$$(date -r "$<" +"%Y-%m-%d %H:%M:%S %:z");\
	 KWDF="$(shell $(kwds-file))";\
	 KWD=$$(cat $$KWDF);\
	 XTR=$$($(ee) \
	"dotmpe.project.mkdoc:filemdatetime\t$$FILEMDATETIME");\
	 $(ee) "$$KWD\n$$XTR" | grep -v '^$$' | grep -v '^#'| \
		while read l; do \
			IFS="	";set -- $$l;\
			[ -z "$$1" ] && echo Empty field 1 && exit 1;\
			[ -z "$$2" ] && echo Empty field 2 $$1= && exit 1;\
			tag=`echo "$$1" | awk '{gsub("[~/:.]", "\\\\\\\&");print}'`; \
			value=`echo "$$2" | awk '{gsub("[~/:.]", "\\\\\\\&");print}'`; \
			sed -e "s/@$$tag/$$value/g" $<.src > $<.tmp; \
			mv $<.tmp $<.src; \
		done;
endef

define post-proc-tags
	@# Process all target files and expand tag references.
	@$(ll) file_target "$@" "Replacing tags in" "$@"
	@cp $@ $@.tmp;
	@chmod +rw $@.tmp
	@KWDF="$(shell $(kwds-file))";\
	 cat $$KWDF | grep -v '^$$' | grep -v '^#'| \
		while read l; do \
			IFS="	";set -- $$l;\
			[ -z "$$1" ] && echo Empty field 1 && exit 1;\
			[ -z "$$2" ] && echo Empty field 2 $$1= && exit 1;\
			tag=`echo "$$1" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`; \
			value=`echo "$$2" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`; \
			sed -e "s/@$$tag/$$value/g" $@.tmp > $@; \
			mv $@ $@.tmp; \
		done; \
		mv $@.tmp $@;
#			#line=$($(ee) $$l | tr '\t' '\n');
#
endef

define build-dir-index
	$(ll) file_target "$@" "Checking" "$<"
	ls $(<D) | sort | $(filter-paths) > $@.tmp
	if test -f $@; then \
	   if test -n "`diff $@ $@.tmp`"; then \
	       mv $@.tmp $@; \
	   	$(ll) file_ok "$@" "Updated index"; \
	   else rm $@.tmp; \
		$(ll) file_ok "$@" "Nothing to do"; fi; \
	else mv $@.tmp $@; \
	   $(ll) file_ok "$@" "New index"; fi
endef

define build-res-index
	$(ll) file_target "$@" "Checking" "$<";\
	D=$$(dirname "$@");\
	[ -d $$D ] || \
		mkdir -p $$D/ \
		&& $(ll) file_target "$$D" "created dir";
	P=$<; \
		[ "$${P:0:1}" != "/" ] && \
		[ "$${P:0:2}" != "./" ] && P=./$$P;\
	echo "# <$@> from <$$P> because <$?>" > $@.tmp; \
	echo "# $$ find $$P $(XTR) " >> $@.tmp;\
	find $$P $(XTR) | sort >> $@.tmp;\
	if test -f \"$@\"; then \
		if test -n "`diff $@ $@.tmp`"; then \
			mv $@.tmp $@; \
			$(ll) file_ok "$@" "Updated index"; \
		else rm $@.tmp; \
			$(ll) file_ok "$@" "Nothing to do"; fi; \
	else \
		mv $@.tmp $@; \
		$(ll) file_ok "$@" "New index"; fi
endef


LOG_LEVELS = \
			 emerg=0 \
			 alert=1 \
			 crit=2 \
			 err=3 \
			 warn=4 \
			 note=5 \
			 info=6 \
			 debug=7 \
			 \
			 error=3 \
			 notice=5 \
			 header=6 \
			 header2=6 \
			 OK=6

define vtty
$(call require-key,LOG_LEVELS,$1)
$(eval $(if \
	$(call echo-if-true,$(VERBOSE) -ge $(call key,LOG_LEVELS,$1)),\
	$(info $(shell $(ll) "$1" "$2" "$3" "$4"))))
endef
chat                = $(eval $(call vtty,$1,$2,$3,$4))
log                 = $(ll) "$1" "$2" "$3" "$4"
log-module          = $(eval $(call vtty,header2,$1,$2))

$(call chat,info,OS, "on "$(OS))
$(call chat,info,HOST, "at '"$(HOST)"'")
$(call chat,info,ROOT, "from '"$(ROOT)"'")



test-python =\
	 if test -n "$(shell which python)"; then \
		$(ll) info "$$TEST_PY" "Testing Python sources.."; \
		\
		if test -n "$(shell which python-coverage)"; \
		then \
			RUN="python-coverage -x test/py/main.py "; \
		fi; \
		if test -n "$(shell which coverage)"; \
		then \
			RUN="coverage run "; \
			if test -n "$$TEST_LIB";\
			then\
				RUN="$$RUN --source=$$TEST_LIB";\
			fi;\
		fi; \
		if test -z "$$RUN"; then \
			$(call chat,warning,$@,Coverage for python not available); \
			RUN=python;\
		fi; \
		$(call chat,attention,$$,$$RUN,$$TEST_PY);\
		$$RUN $$TEST_PY $$ARGS; \
		$(call chat,header,exit-status,$$?);\
		$(call zero_exit_test,$$?,$@,Python tested,Python testing failed); \
		\
		if test -n "$(shell which coverage)"; \
		then \
			coverage html; \
			[ -n "$$HTML_DIR" ] && rm -rf $$HTML_DIR && mv htmlcov $$HTML_DIR;\
			$(call chat,notice,$$HTML_DIR,Generated test coverage report in HTML); \
		fi; \
	else \
		$(ll) error "$@" "Tests require Python interpreter. "; \
	fi


log-special-target-because-from = \
	$(ll) attention "$@" because "$?";\
	$(ll) attention "$@" from "$^"

log-file-target-because-from = \
	$(ll) file_target "$@" because "$?";\
	$(ll) file_target "$@" from "$^"


#      ------------ -- 

include                $(MK_SHARE)Core/Main.bin.mk

#      ------------ -- 

default:

list-bin:
	@\
	echo $(BIN);\
	if $(call require-bin,hg); then \
		echo hg=$$$(call get-bin,hg); \
	fi;\
	if $(call require-bin,bzr); then \
		echo bzr=$$$(call get-bin,bzr); \
	fi;\
	if $(call require-bin,svn); then \
		echo svn=$$$(call get-bin,svn); \
	fi;\
	if $(call require-bin,git); then \
		echo git=$$$(call get-bin,git); \
	fi;\
	if $(call require-bin,python); then \
		echo python=$$$(call get-bin,python); \
	fi



#      ------------ -- 
#
