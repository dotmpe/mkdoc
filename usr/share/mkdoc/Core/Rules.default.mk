MK_$d               += $(MK_SHARE)Core/Rules.default.mk
include                $(MK_SHARE)Core/Main.makefiles.mk

default:              stat

## Include required and dynamic Makefiles
-include              $(DMK)

## Add default MkDoc targets and set special targets
STD                := $(STDTRGT) $(STDSTAT)
STRGT 			   += $(STD)
.PHONY: 		      $(STRGT)

### Standard Rule(s)
help::
	@$(ee) 
	@# See STRGT and DESCRIPTION vars, STD (STDTARGT or STDSTAT) without DESCRIPTION is not printed
	@declare $(DESCRIPTION);\
	$(ll) header $@     "$(PACKAGE) Makefile";\
	$(ee) "" ;\
	for strgt in $(STDTRGT);\
	do\
		V=$$strgt;\
		if test -n "$${!V}";\
		then\
			$(ll) header2 $$strgt "$${!V}";\
		fi;\
	done;\
	echo;\
	$(ll) header $@     "No-ops and summary targets";\
	for strgt in $(STDSTAT);\
	do\
		V=$$strgt;\
		if test -n "$${!V}";\
		then\
			$(ll) header2 $$strgt "$${!V}";\
		fi;\
	done;\
	OTHER="$(call complement,$(STRGT),$(STD))";\
	if test -n "$$OTHER";\
	then\
		echo;\
		$(ll) header $@     "Other special targets";\
		for strgt in $(call complement,$(STRGT),$(STD));\
		do\
			strgt_id=$$(echo $$strgt|sed 's/[\/\.,;:_\+-]/_/g');\
			$(ll) header2 $$strgt "$${!strgt_id}";\
		done;\
		$(ee);\
	fi;
	@$(ll) OK $@ 

examples::
	@$(ee)
	@$(ll) header       "$@" "The following is an example list of log output lines"
	@$(ee)
	@$(ll) file_target "./example/path.o" "(file_target) File targets and other paths use angle brackets" "and a list of paths"
	@$(ll) file_ok "./example/path.o" "(file_ok) this is a message to be printed" "with another list of paths"
	@$(ee)
	@$(ll) done         "$@" "Special targets use square brackets" "and may always list paths"
	@$(ll) ok           "$@" "this is a message to be printed" "with another list of paths"
	@$(ll) OK           "$@" "see that line-types are case-insensitive"
	@$(ll) header       "$@" "This line type (header1) is not included on the line"
	@$(ll) header2      "$@" "(header2) This is a message to be printed" 
	@$(ll) header3      "$@" "(header3) This is a message to be printed" 
	@$(ll) debug        "$@" "(debug) This is a message to be printed" 
	@$(ll) info         "$@" "(info) This is a message to be printed" 
	@$(ll) attention    "$@" "(attention) This is a message to be printed" 
	@$(ll) warning      "$@" "(warning) This is a message to be printed" 
	@$(ll) error        "$@" "(error) this is a message to be printed" 
	@$(ll) fatal        "$@" "this script better halt now"
	@$(ll) "* (type?)"  "$@" "All logs are printed, including those with unrecognized linetype" 

info::
	@$(ll) header $@ "Package Info"
	@$(ll) header2 Root     "" $(ROOT)
	@$(ll) header2 MkDoc    "" $(MK_SHARE)
	@$(ll) header2 Package  "" "$(PACKAGE)"
	@$(ll) header2 Package  "" "$$PROJECT"
	@$(ll) header2 Package  "" "$(PACK)"
	@$(ll) header2 Homepage "" $(PACK_HREF)
	@$(ll) header2 Revision "" $(PACK_REV)
	@$(ll) header2 Version  "" $(PACK_V)
	@$(ll) header2 Release  "" $(TAG)
	@$(ll) header3 CS "$(CS)" "$(origin CS)"
	@$(ll) header3 VPATH "$(VPATH)" "$(origin VPATH)"
	@$(ll) header3 SHELL "$(SHELL)" "$(origin SHELL)"
	@$(ll) header3 HOST "$(HOST)" "$(origin HOST)"
	@$(ll) header3 OS "$(OS)" "$(origin OS)"
	@$(ll) header3 VERBOSE "$(VERBOSE)" "$(origin VERBOSE)"
	@$(ll) OK $@ 

# TODO use similar scheme as DESCRIPTION
DESC_SRC  = Paths to build targets from  
DESC_TRGT = Paths to build from source 
DESC_TEST =  
DESC_MK   = List of loaded Makefiles
DESC_DMK  = List of (to be) generated Makefiles
DESC_DEP  = Paths needed to build targets 
DESC_CLN  = Paths that will be removed on next `make clean`  
DESC_RES  =   


#src:: $(SRC) 

dep:: $(SRC) $(DEP)
	@if test -n "$(strip $(DEP))"; then \
		$(call log,Done,$@,$(call count,$(DEP)) generated dependencies ready); \
	else \
		$(ll) OK $@ "nothing to do"; \
	fi

dmk:: dep $(DMK)
	@if test -n "$(strip $(DMK))"; then \
		$(call log,Done,$@,$(call count,$(DMK)) generated makefiles ready); \
	else \
		$(ll) OK $@ "nothing to do"; \
	fi

stat:: LIST := 
stat:: dmk
	@if test -n "$(VERBOSE)"; then \
		echo;\
		$(call log,header1,$@,Target prereq. counts:);\
		$(call log,header3,Sources,$(call count,$(SRC)));\
		$(call log,header3,Dependencies,$(call count,$(DEP)));\
		$(call log,header3,Dynamic makefiles,$(call count,$(DMK)));\
		$(call log,header3,Cleanable,$(call count,$(CLN)));\
		$(call log,header3,Targets,$(call count,$(TRGT)));\
		$(call log,header3,Special Targets,$(call count,$(STRGT)));\
		$(call log,header3,Tests,$(call count,$(TEST)));\
		$(call log,header3,Resources,$(call count,$(RES)));\
		echo;\
	fi
	@if [ "$(LIST)" = "build" ]; then \
		if test -n "$(wildcard $(sort $(TRGT)))"; then \
			$(ll) header2 TRGT 'Build Targets' '$(wildcard $(sort $(TRGT)))';\
		else\
			$(ll) header2 TRGT 'Build Targets (none)';\
	 fi; fi;
	@if [ "$(LIST)" = "clean" ]; then \
		if test -n "$(wildcard $(sort $(CLN)))"; then \
			$(ll) Attention "Cleanable" "paths found:" '$(wildcard $(sort $(CLN)))';\
		else\
			$(ll) header2 TRGT 'Cleanable Targets (none)';\
	 fi; fi;
	@if [ "$(LIST)" = "source" ]; then \
		if test -n "$(wildcard $(sort $(SRC)))"; then \
			$(ll) header2 SRC Sources '$(wildcard $(sort $(SRC)))';\
		else\
			$(ll) header2 SRC "Sources (none)";\
	 fi; fi;
	@if [ "$(LIST)" = "test" ]; then \
		if test -n "$(wildcard $(sort $(TEST)))"; then \
			$(ll) header2 TEST Tests '$(wildcard $(sort $(TEST)))';\
		else\
			$(ll) header2 TEST "Tests (none)";\
	 fi; fi;
	@if [ "$(LIST)" = "dmk" ]; then \
		if test -n "$(wildcard $(sort $(DMK)))"; then \
			$(ll) header2 'Generated Makefiles' '$(wildcard $(sort $(DMK)))';\
		else\
			$(ll) header2 'Generated Makefiles (none)';\
	 fi; fi;
	@if [ "$(LIST)" = "dep" ]; then \
		if test -n "$(wildcard $(sort $(DEP)))"; then \
			$(ll) header2 'Other Dependencies' '$(wildcard $(sort $(DEP)))';\
		else\
			$(ll) header2 'Other Dependencies (none)';\
	 fi; fi;
	@if [ "$(LIST)" = "strgt" ]; then \
		if test -n "$(wildcard $(sort $(STRGT)))"; then \
			$(ll) header2 'Special Targets' '$(wildcard $(sort $(STRGT)))';\
		else\
			$(ll) header2 'Special Targets (none)';\
	 fi; fi;
	@if [ "$(LIST)" = "res" ]; then \
		if test -n "$(wildcard $(sort $(RES)))"; then \
			$(ll) header2 'Resources' '$(wildcard $(sort $(RES)))';\
		else\
			$(ll) header2 'Resources (none)';\
	 fi; fi;
	@OFFLINE=$(sort $(abspath $(OFFLINE)));\
	 if test -n "$$OFFLINE"; then \
		$(ll) Warning "Offline" "directories unavailable:" "$$OFFLINE";\
	 fi;
	@if test -n "$(sort $(MISSING))"; then \
	   $(ll) Error "Missing" "paths not found:" '$(sort $(MISSING))';\
	 fi;
	@if test -n "$(sort $(PENDING))"; then \
	   $(ll) Done $@ \
	 "counted $(call count,$(SRC)) sources, $(call count,$(TRGT)) targets"; \
	   $(ll) Attention "Pending" "Please rebuild [$@] because:" '$(sort $(PENDING))';\
	 else \
	   $(ll) OK $@ \
	 "counted $(call count,$(SRC)) sources, $(call count,$(TRGT)) targets"; fi

build:: stat $(TRGT)
	@$(call log,Done,$@,$(call count,$(TRGT)) targets ready)

# TODO: add some scaffolding for pub/rsync/..?
pub:: push build
	@$(call log,Done,$@,$(call count,$(TRGT)) targets ready)

push::
	@$(call log,Done,$@,$(call count,$(TRGT)) targets ready)

test:: $(TEST)
	$(call mk_ok_s,"tested")

clean:: F := f
clean::
	@$(ll) warning $@ cleaning "$(CLN)"
	@-rm -$(F) $(CLN);\
	 if test $$? -gt 0; then echo ""; fi; # put xtra line if err-msgs
	@$(call log,Done,$@,$(call count,$(CLN)) targets)

clean-dep:: cleandep

cleandep::
	@$(ll) warning $@ "cleaning dependencies" "$(DEP) $(DMK)"
	@-rm $(DEP) $(DMK);\
	 if test $$? -gt 0; then echo; fi; # put extra line if err-msg
	@$(ll) OK $@ "$(call count,$(DEP) $(DMK)) dependencies removed"

#install: test
#	@$(echo) -e " $(mk_ok)  $(c2)nothing to install.$(c0)"

all:: build test install
	$(call log,Done,$@,"built, tested and installed")


