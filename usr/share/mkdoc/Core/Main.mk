### MkDocs Core Makefile
# :Date: 2010-10-04
# :Last Update: 2011-01-16
# :Author: B. van Berkum  <dev@dotmpe.com>
#
# This is a non-recursive makefile,
# see Rules.mk for each directory.
#
# To use MkDoc, include this file in your projects main Makefile first.
# Finally, include some standard rules or set these yourself. See:
# $(MK_SHARE)Core/Rules.default.mk

VPATH              := . /
SHELL              := /bin/bash

.SUFFIXES:
.SUFFIXES:         .rst .js .xhtml .mk .tex .pdf .list

MK_ROOT            := ~/project/mkdoc/
MK_SHARE           := $(MK_ROOT)usr/share/mkdoc/

HOST               := $(shell hostname -s | tr 'A-Z' 'a-z')
ifndef ROOT
ROOT               := $(shell pwd)
endif
OS                 := $(shell uname)


# global path/file lists
SRC                :=
DMK                :=
MK                 :=
DEP                :=
TRGT               :=
STRGT              :=
CLN                :=
TEST               :=
INSTALL            :=

PENDING            :=
MISSING            :=
OFFLINE            :=

RES :=


### standard targets
# (append to STRGT) see Rules.default.mk
STDTRGT            := \
					  all dep dmk test build install clean cleandep
STDSTAT            := \
					  help stat list lists info
# descriptions of special targets for build
DESCRIPTION        := all='build, test and install'
DESCRIPTION        += dep='generate dependencies'
DESCRIPTION        += dmk='generate dynamic makefiles'
DESCRIPTION        += test='TODO: run tests'
DESCRIPTION        += build='builds all targets'
DESCRIPTION        += install='TODO (no-op)'
DESCRIPTION        += clean='delete all targets'
DESCRIPTION        += cleandep='delete all dynamic makefiles and dependencies'

DESCRIPTION        += help='print this help'
DESCRIPTION        += stat='assert sources, dynamic makefiles and other dependencies'
DESCRIPTION        += list='print SRC and TRGT lists'
DESCRIPTION        += lists='print all other lists'
DESCRIPTION        += info='print other metadata'


### Various snippets

ll                  = $(MK_SHARE)Core/log.sh

ifneq ($(VERBOSE), )
$(info $(shell $(ll) "info" "OS" "on "$(OS)))
$(info $(shell $(ll) "info" "HOST" "at '"$(HOST)"'"))
$(info $(shell $(ll) "info" "ROOT" "from '"$(ROOT)"'"))
endif

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


### Functions

log                 = $(ll) "$1" "$2" "$3" "$4"
log_line            = $(ll) "$1" "$2" "$3" "$4"
# log:  1.LINETYPE  2.TARGETS  3.MESSAGE  4.SOURCES
log-module          = # $1 $2
ifneq ($(VERBOSE), )
log-module          = $(info $(shell if test -n "$(VERBOSE)"; then \
						$(ll) header2 $1 $2; fi))
endif
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
mkid                = $(shell echo $1|sed 's/[\/\.,;:_\+]/_/g')
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
# complement: return items from $1 not in $2
complement          = $(shell \
					    for X in $1; do \
					      if test -z "$$(for Z in $2; do if test "$$Z" = "$$X"; \
					        then echo $$X; fi; done)"; then \
					        echo "$$X"; fi; done; )
f_getpaths          = $(shell F="$1"; $(getpaths))
zero_exit_test = \
	if test $1 != 0; \
	then \
		$(ll) error "$2" "$4"; \
	else \
		$(ll) OK "$2" "$3"; \
	fi


### Canned
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
target-stats         = \
					$(info-target-lines);\
					$(info-target-chars);\
					$(info-target-type);
info-text-stat = $(ll) info "$@" "`cat $@|wc -l` lines, `cat $@|wc -m` chars, `file -bs $@`"
info-bin-stat = $(ll) info "$@" "`cat $@|wc -c` bytes, `file -bs $@`"

define mk-include
	$(reset-target)
	for f in $(MK_FILES); do \
		echo "ifeq (\$$(realpath $$f 2>/dev/null),)" >> $@; \
		echo "MISSING += $$f" >> $@; \
		echo "else" >> $@; \
		echo "DIR := `dirname $$f`" >> $@; \
		echo "include $$f" >> $@; \
		echo "endif" >> $@; \
	done;
endef

define ante-proc-tags
	# Process all source files and expand tag references.
	$(ll) info "source tags" "Expanding keywords tags from " $$($(kwds-file))
	if test ! -f "$<.src"; then cp $< $<.src; fi
	FILEMDATETIME=$$(date -r "$<" +"%Y-%m-%d %H:%M:%S %:z");\
	 KWDF="$(shell $(kwds-file))";\
	 KWD=$$(cat $$KWDF);\
	 XTR=$$($(ee) \
	"dotmpe.project.mkdoc:filemdatetime\t$$FILEMDATETIME");\
	 $(ee) "$$KWD\n$$XTR" | grep -v '^$$' | grep -v '^#'| \
		while read l; do \
			IFS="	";set -- $$l;\
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

chatty =\
		if test -z "$$VERBOSE"; then VERBOSE=1; fi;\
		if test $$VERBOSE -ge $1;\
		then \
			$(ll) "$2" "$3" "$4" "$5"; \
		fi


test-python =\
	 if test -n "$(shell which python)"; then \
		$(ll) info "$$TEST_PY" "Testing Python sources.."; \
		\
		if test -n "$(shell which coverage)"; \
		then \
			RUN="coverage run "; \
			if test -n "$$TEST_LIB";\
			then\
				RUN=$$RUN" --source="$$TEST_LIB;\
			fi;\
		else \
			$(call chatty,1,warning,$@,Coverage for python not available); \
			RUN=python;\
		fi; \
		$(call chatty,2,attention,$$,$$RUN,$$TEST_PY);\
		$$RUN $$TEST_PY; \
		$(call chatty,2,header,exit-status,$$?);\
		$(call zero_exit_test,$$?,$@,Python tested,Python testing failed); \
		\
		if test -n "$(shell which coverage)"; \
		then \
			coverage html; \
			$(call chatty,0,file_OK,htmlcov/,Generated test coverage report in HTML); \
		fi; \
	else \
		$(ll) error "$@" "Tests require Python interpreter. "; \
	fi;


log-target-because-from = \
	$(ll) file_target "$@" because "$?";\
	$(ll) file_target "$@" from "$^";

default:

