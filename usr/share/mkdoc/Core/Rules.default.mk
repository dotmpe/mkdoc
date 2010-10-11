MK                 += $(MK_SHARE)Core/Rules.default.mk

default:              stat

## Include required and dynamic Makefiles
-include              $(DMK)

## Add default MkDoc targets and set special targets
STRGT 			   += default stat help info list lists dmk dep build test \
					  clean clean-pyc install all
.PHONY: 		      $(STRGT)


### Standard Rule(s)
help:
	@$(ee) 
	@$(ll) header $@     "Scrow project Makefile"
	@$(ee) 
	@$(ll) header2 all   "build, test and install"
	@$(ll) header2 dep   "generate dependencies"
	@$(ll) header2 dmk   "generate dynamic makefiles"
	@$(ll) header2 test  "TODO: run tests"
	@$(ll) header2 build "builds all targets"
	@$(ll) header2 install "TODO (no-op)"
	@$(ll) header2 clean "delete all targets"
	@$(ll) header2 clean-dep "delete all dynamic makefiles and dependencies"
	@$(ee) 
	@$(ll) header $@     "No-ops and summary targets:"
	@$(ll) header2 help "."
	@$(ll) header2 stat  "assert sources, dynamic makefiles and other dependencies."
	@$(ll) header2 list "."
	@$(ll) header2 lists  "."
	@$(ll) header2 info  "."
	@$(ee) 
	@$(ll) OK $@ 

info:
	@$(ll) header $@ "Package Info"
	@$(ll) header2 Root     "" $(ROOT)
	@$(ll) header2 MkDoc    "" $(MK_ROOT)
	@$(ll) header2 Package  "" $(PACK)
	@$(ll) header2 Homepage "" $(PACK_HREF)
	@$(ll) header2 Revision "" $(PACK_REV)
	@$(ll) header2 Version  "" $(PACK_V)
	@$(ll) header2 Release  "" $(TAG)
	@$(ll) OK $@ 

list:
	@$(ee) 
	@$(ll) header2 Sources "" "$(strip $(SRC))"
	@#$(ll) header2 Sources  "$(shell echo $(SRC)|sort -u)"
	@$(ll) header2 "Build Targets" "" '$(strip $(TRGT))'
	@$(ll) OK $@ 

lists:
	@$(ll) header $@ "All targets"
	@$(ll) header2 Sources               ""  '$(strip $(SRC))'
	@$(ll) header2 "Build Targets"       ""  '$(strip $(TRGT))'
	@$(ll) header2 "Test Targets"        ""  '$(strip $(TEST))'
	@$(ll) header2 "Makefiles"  	     ""  '$(strip $(MK))'
	@$(ll) header2 "Generated Makefiles" ""  '$(strip $(DMK))'
	@$(ll) header2 "Other Dependencies"  ""  '$(strip $(DEP))'
	@$(ll) header2 "Resources "  ""  '$(strip $(RES))'
	@if test -n "$(strip $(MISSING))"; then \
	 $(ll) Error "Missing" "Paths not found " '$(strip $(MISSING))';\
	 fi;

	@#$(ll) header2 "All Generated Targets" '$(strip $(CLN))'
	@$(ll) OK $@ 

stat: $(SRC) dep dmk
	@OFFLINE=$(strip $(abspath $(OFFLINE)));\
	 if test -n "$$OFFLINE"; then \
 	   $(ll) Warning "Offline" "directories unavailable:" "$$OFFLINE";\
	 fi;
	@if test -n "$(strip $(MISSING))"; then \
 	   $(ll) Error "Missing" "paths not found:" '$(strip $(MISSING))';\
	 fi;
	@if test -n "$(strip $(PENDING))"; then \
 	   $(ll) Warning "Pending" "Please rebuild [$@] because:" '$(strip $(PENDING))';\
	 else \
	   $(ll) OK $@ \
	 "counted $(call count,$(SRC)) sources, $(call count,$(TRGT)) targets"; fi

build: stat $(TRGT)
	@$(call log,Done,$@,$(call count,$(TRGT)) targets ready)

dep: $(DEP)
	@$(call log,Done,$@,$(call count,$(DEP)) generated dependencies ready) 

dmk: dep $(DMK)
	@$(call log,Done,$@,$(call count,$(DMK)) generated makefiles ready) 

#test: dep $(TEST)
#	$(call mk_ok_s,"tested")

clean:
	@$(ll) warning $@ cleaning "$(CLN)"
	@-rm -f $(CLN);\
	 if test $$? -gt 0; then $(echo) ""; fi; # put xtra line if err-msgs
	@$(call log,Done,$@,$(call count,$(CLN)) targets)

clean-dep:
	@$(ll) warning $@ "cleaning dependencies" "$(DEP) $(DMK)"
	@-rm $(DEP) $(DMK);\
	 if test $$? -gt 0; then echo; fi; # put extra line if err-msg
	@$(ll) OK $@ "$(call count,$(DEP) $(DMK)) dependencies removed"

#install: test
#	@$(echo) -e " $(mk_ok)  $(c2)nothing to install.$(c0)"

all: build test install
	$(call log,Done,$@,"built, tested and installed")


