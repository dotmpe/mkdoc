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

VPATH               := . /
SHELL               := /bin/bash

.SUFFIXES:
.SUFFIXES:          .rst .js .xhtml .mk .tex .pdf .list

PREFIX              ?= /usr/local
MK_SHARE            := $(PREFIX)/share/mkdoc/

HOST                := $(shell hostname -s | tr 'A-Z' 'a-z' | tr '.' '-')
ifndef ROOT
ROOT                := $(shell pwd)
endif
OS                  := $(shell uname)


# global path/file lists
SRC                 :=
DMK                 :=
MK                  += $(MK_SHARE)Core/Main.mk
DEP                 :=
TRGT                :=
STRGT               :=
CLN                 :=
CLEAN               :=
TEST                :=
INSTALL             :=

PENDING             :=
MISSING             :=
OFFLINE             :=
RES                 :=

STAT                :=

#      ------------ --


### standard targets
# (append to STRGT) see Rules.default.mk
STDTRGT             := all dep dmk test build install clean clean-dep cleandep
STDSTAT             := stat list version \
											 help help-stdvars help-allvars help-vars help-targets \
											 examples info \
											 pub push
STD                := $(STDTRGT) $(STDSTAT)

ALLVARS             := SRC DMK DEP TRGT STRGT CLN CLEAN TEST INSTALL \
	PENDING MISSING OFFLINE RES \
	STDTRGT STDSTAT STAT STD


# Descriptions for default special-targets

DESCRIPTION         += stat='default target; assert sources, dynamic makefiles and other dependencies exists'
DESCRIPTION         := all='build, test and install'
DESCRIPTION         += dep='generate dependencies'
DESCRIPTION         += dmk='generate dynamic makefiles'
DESCRIPTION         += test='TODO: run tests'
DESCRIPTION         += build='builds all targets'
DESCRIPTION         += install='TODO (no-op)'
DESCRIPTION         += clean='delete all targets'
DESCRIPTION         += cleandep='delete all dynamic makefiles and dependencies'

DESCRIPTION         += help='print this help'
DESCRIPTION         += helptargets='print info about special-targets [STDTRGT,STDSTAT,STRGT]'
DESCRIPTION         += helpvars='print info about vars [VARS]'
DESCRIPTION         += info='print other metadata'


DESCRIPTION         += describe_SRC='Source-paths, usually static, version controlled project files'
DESCRIPTION         += describe_TRGT='Test Targets: prerequisites before `make build`, usually paths build from source'
DESCRIPTION         += describe_TEST='Build Targets: prerequisites before `make test`'
DESCRIPTION         += describe_MK='List of loaded Makefiles'
DESCRIPTION         += describe_DMK='List of (to be) generated Makefiles, maybe pending'
DESCRIPTION         += describe_DEP='Prerequisites for `dep` or `dmk`, that are not source or makefiles'
DESCRIPTION         += describe_CLN='Paths to remove on `clean`'
DESCRIPTION         += describe_CLEAN='Prerequisites before `clean`'
DESCRIPTION         += describe_RES='Resources ?'
DESCRIPTION         += describe_PENDING='At any time, targets in PENDING indicate a partial build, and at least one a re-run is required'
DESCRIPTION         += describe_STRGT='Non-file or -path (ie. PHONY) special-targets'
DESCRIPTION         += describe_STDTRGT='Internal Mkdoc STRGT targets'
DESCRIPTION         += describe_STAT='No-op checks, statistics and summary targets'
DESCRIPTION         += describe_STDSTAT='Internal Mkdoc STAT targets'
DESCRIPTION         += describe_STD='Built-in Mkdoc targets'
DESCRIPTION         += describe_ALLVARS='Global described vars'


# NOTE: unsure if GNU/Make can give info about target prerequisites. 
# Instead, document with vars.
#
# DESCRIPTION += <STRGT>='Description for special-target'
# DESCRIPTION += describe_<VAR>='Description for variable name'
#
# Note: varnames are char restricted, though GNU/Make only disallows ':#='.
# XXX: Maybe can describe other path or file targets?



### Various shellscript snippets

ifeq ("$(OS)","Darwin")
ee                   = /bin/echo
else
ee                   = /bin/echo -e
endif
sed-trim             = sed 's/^ *//g' | sed 's/ *$$//g'
# really limited escape..
sed-escape           = awk '{gsub("[~/:.]", "\\\\&");print}'
filter-file-lines    = grep -v ^\# | grep -v ^\s*$$
trim-paths           = sed 's/\/\//\//g' | sed 's/\.\///g'
getlines             = echo $$(cat "$$F" | $(filter-file-lines))
ifeq ("$(OS)","Darwin")
sed-in-place-rewrite          = sed -i.sed-backup 
else
sed-in-place-rewrite          = sed 
endif

### Functions

echo-if-true         = $(shell [ $1 ] && echo true)
key                  = $(shell declare $($1); echo "$$$2")
get-value           := $($1)
get-bin              = $(call key,BIN,$1)
#key                  = $(shell declare $($1); [ -z "$$$2" ] && ( echo missing $2; exit 1) || (echo $$$2))
define require-key
$(if $(call key,$1,$2),,$(error $(shell $(ll) "error" mkdocs "Missing key $2 for $1")))
endef
last                 = $(word $(words $(1)),$(1))
# complement: return items from $1 not in $2
complement           = $(shell \
                         for X in $1; do \
                           if test -z "$$(for Z in $2; do if test "$$Z" = "$$X"; \
                             then echo $$X; fi; done)"; then \
                             echo "$$X"; fi; done; )
has-duplicates       = $(filter $(words $1), $(words $(sort $1)))
paths-exist          = $(filter $(wildcard $1),$1)
not-exist            = $(call complement,$1,$(call paths-exist,$1))

init-dir             = if test ! -d $1; then mkdir -p $1; fi
init-file            = if test ! -f $1; then mkdir -p $$(dirname $1); touch $1; fi
count                = $(shell if test -n "$1"; then\
                         echo $1|wc -w|sed 's/ //g'; else echo 0; fi;)
count-list           = $(shell if test -f "$1"; then\
                         cat $1|wc -l; else echo 0; fi;)
count-lines          = wc -l "$$F" | sed 's/^\ *\([0-9]*\).*$$/\1/g'
f-count-lines        = $(shell F=$1; $(count-lines))
contains-sh          = for Z in "$1"; do if test "$$Z" = "$2"; then \
                         echo "$$Z"; fi; done;
contains             = $(shell $(call contains-sh,$1,$2))
expand-path          = $(shell echo $1)
#exists               = $(shell realpath "$1" 2> /dev/null)
exists               = $(shell [ -e "$1" ] && echo "$1")
is-path              = $(shell if test -e "$1";then echo $1; fi;)
is-file              = $(shell if test -f "$1";then echo $1; fi;)
is-dir               = $(shell if test -d "$1";then echo $1; fi;)
filter-dir           = $(shell for D in $1; do if test -d "$$D"; then \
                         echo $$D; fi; done)
filter-file          = $(shell for F in $1; do if test -f "$$F"; then \
                         echo $$F; fi; done)
clean-plist          = $(sort $(strip $1))
newer-than           = $(shell for F in $2; do if test $$F -nt $1; then echo $$F newer than $1; fi; done; )
f-sed-escape         = $(shell echo "$1" | $(sed-escape))
remove-line          = if test -e "$1"; then LINE=$$(echo $2|$(sed-escape));mv "$1" "$1.tmp";cat "$1.tmp"|sed "s/$$LINE//">"$1";rm $1.tmp; else echo "Error: unknown file $1"; fi
assert-line          = if test -z "$$(cat $1|grep $2)";then echo "$2" >> $1; fi;
filter-mount         = $(foreach M,$1,$(if $(shell mount|grep $M),$(shell echo $M)))
sub-dirs             = $(abspath $(realpath $(shell \
                         for sub in $1/*; do \
                           if test -d "$$sub"; then \
                             echo "$$sub"; fi; done)))
safe-paths           = $(shell D="$(call f-sed-escape,$1)";\
                         ls "$1"|grep '^[\/a-zA-Z0-9\+\.,_-]\+$$'|sed "s/^/$$D/g")
unsafe-paths         = $(shell D="$(call f-sed-escape,$1)";\
                         ls "$1"|grep -v '^[\/a-zA-Z0-9\+\.,_-]\+$$'|sed "s/^/$$D/g")
# mkid: rewrite filename/path to Make/Bash safe variable ID
mkid                 = $(shell echo $1|sed 's/[\/\.,;:_\+]/_/g')
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
sub-rules            = $(foreach V,$1,$(call rules,$V/*))
f_getlines           = $(shell F="$1"; $(getlines))

#parents              = $()
# rules: return Rules files for each directory in $1
# XXX testing wildcard function
#rules                = $(shell for D in $1; do \
#                         if test -f "$$(echo $$D/Rules.mk)"; then \
#                           echo $$D/Rules.mk; else \
#                         if test -f "$$(echo $$D/.Rules.mk)"; then \
#                           echo $$D/.Rules.mk; else \
#                         if test -f "$$(echo $$D/Rules.$(HOST).mk)"; then \
#                           echo $$D/Rules.$(HOST).mk; else \
#                         if test -f "$$(echo $$D/.Rules.$(HOST).mk)"; then \
#                           echo $$D/.Rules.$(HOST).mk; fi; fi; fi; fi; done )
# sub-rules: return ./*/[.]Rules[.host].mk, ie. rules from subdirs
sub-rules            = $(foreach V,$1,$(call rules,$V/*))
f_getpaths           = $(shell F="$1"; $(getpaths))
zero_exit_test       = \
	if test $1 != 0; \
	then \
		$(ll) error "$2" "$4"; \
	else \
		$(ll) OK "$2" "$3"; \
	fi


# Given that $(DESCRIPTION) is declared, print descriptions on (special) targets
describe-targets = for T in $(1); do \
		if test -n "$${!T}"; \
		then $(ll) header2 $$T "$${!T}"; \
		else $(ll) header2 $$T "(no description)"; \
	fi; done


#htd-prefix = $$(htd prefixes names $1 | tr '\n' ' ')
htd-prefix := echo $1

# Given that $(DESCRIPTION) is declared, print descriptions on variables
describe-vars = for V in $$(echo "$(1)" | tr -sc 'A-Za-z0-9_ '); do\
			var_descr=describe_$${V}; \
			$(ll) header3 "$$V" "$${!var_descr}" "$${!V}";\
			sh $(MK_SHARE)Core/find-mk-def.sh $$V || continue; \
			echo ;\
		done

define declare-help
	@declare $(DESCRIPTION) ;  \
		eval declare $(foreach VAR,$(VARS),$(VAR)=\"$($(VAR))\")
endef

define help-vars
	@echo ; FIRSTTAB=12 $(ll) header "$@" \
		"Listing value and declarations of (VARS)" "$(VARS)"
	$(declare-help) ; echo ; export MK="$(MK)"; $(call describe-vars,$(VARS))
endef


# Output, verbosity, ... log?

ll                   = $(MK_SHARE)Core/log.sh
# ll/log             1.LINETYPE  2.TARGETS  3.MESSAGE  4.SOURCES
log                  = $(ll) "$1" "$2" "$3" "$4"
log-module           = # $1 $2
ifneq ($(VERBOSE), )
log-module           = $(info $(shell if test -n "$(VERBOSE)"; then \
                         $(ll) header2 "$1" "$2"; fi))
endif


# "chatter on tty"
chatty               =\
		if test -z "$$VERBOSE"; then VERBOSE=1; fi;\
		if test $$VERBOSE -ge $1;\
		then \
			$(ll) "$2" "$3" "$4" "$5"; \
		fi

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
	$(call echo-if-true,$(VERBOSE) -ge "$(call key,LOG_LEVELS,$1)"),\
	$(info $(shell $(ll) "$1" "$2" "$3" "$4"))))
endef

chat                = $(eval $(call vtty,$1,$2,$3,$4))


# Output a header upon loading include
# Args: headername, filename, description
define module-header
MK += $2
$(call log-module,$1,$3,$2)
endef

# Like module-header but before header increment dirstack too
# Args: fromdir, subdir, description
define dir-header
include                $(MK_SHARE)Core/Main.dirstack.mk
MK_$d               := $1/$2
$(eval $(call module-header,,$/$2,$3))
endef



### Canned
init-target          = $(call init-file,$@)
mk-target-dir        = if test ! -d $(@D); then mkdir -p $(@D); fi;
#XXX: this looks at far to many places, overriding others and forcing duplication?
# but content is generated per definition anyway
kwds-file            = if test -f "$(KWDS_./$(<D))"; then \
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
						  echo $(KWDS_.); fi; fi; fi; fi; fi; fi;

define mk-target
	$(mk-target-dir)
	if test ! -f "$@"; then touch $@; fi;
endef

define reset-target
	$(mk-target-dir)
	if test -f "$@"; then rm $@; fi;
	touch $@;
endef


info-target-type     = $(ll) info "$@" "`file -bs $@`"
info-target-chars    = $(ll) info "$@" "`cat $@|wc -m` chars"
info-target-lines    = $(ll) info "$@" "`cat $@|wc -l` lines"
info-text-stat       = $(ll) info "$@" "`cat $@|wc -l` lines, `cat $@|wc -m` chars, `file -bs $@` formatted"
info-bin-stat        = $(ll) info "$@" "`cat $@|wc -c` bytes, `file -bs $@` format"

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

ifeq ($(OS),Darwin)
CMD_STATC := stat -f
else
CMD_STATC := stat -c 
endif

define ante-proc-tags
	# Process all source files and expand tag references.
	echo "Running ante-proc-tags"
	if test ! -f "$<.src"; then cp $< $<.src; fi
	mtime=$$($(CMD_STATC) %m "$<");\
	FILEMDATETIME="$$(date -r "$$mtime" +"%Y-%m-%d %H:%M:%S %z")";\
	 KWDF="$(shell $(kwds-file))";\
	 KWD=$$(cat $$KWDF);\
	 XTR=$$(echo -e "\ndotmpe.project.mkdoc:filemdatetime\t$$FILEMDATETIME");\
	echo "$$KWD$$XTR" | $(filter-file-lines) | \
		while read l; do \
			IFS="	";set -- $$l;\
			[ -z "$$1" ] && echo Empty field 1 && exit 1;\
			[ -z "$$2" ] && echo Empty field 2 $$1= && exit 1;\
			tag=`echo "$$1" | awk '{gsub("[~/:.]", "\\\\\\\&");print}'`; \
			value=`echo "$$2" | awk '{gsub("[~/:.]", "\\\\\\\&");print}'`; \
			sed 's/^\(.*\)@'$$tag'\(.*\)$$/\1'$$value'\2/g' $<.src > $<.tmp; \
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
endef

define build-dir-index
	$(ll) file_target "$@" "Checking" "$<"
	ls $(<D) | sort | $(filter-file-lines) > $@.tmp
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



#ifneq ($(VERBOSE), )
#$(info $(shell $(ll) "info" "OS" "on "$(OS)))
#$(info $(shell $(ll) "info" "HOST" "at '"$(HOST)"'"))
#$(info $(shell $(ll) "info" "ROOT" "from '"$(ROOT)"'"))
#endif


log-special-target-because = \
	$(ll) attention "$@" because "$?"

log-file-target-because = \
	$(ll) file_target "$@" because "$?"

log-special-target-because-from = \
	$(ll) attention "$@" because "$?";\
	$(ll) attention "$@" from "$^"

log-file-target-because-from = \
	$(ll) file_target "$@" because "$?";\
	$(ll) file_target "$@" from "$^"

default:

