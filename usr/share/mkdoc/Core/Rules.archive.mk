## Dirstack
$(call chat,info,$/,"Archive make. " )
$(call chat,debug,make,$(DIR)/Rules.archive.mk)
SP                  := $(SP).x
D_$(SP)             := $d
d                   := $(DIR)

MK_$d               += $d/Rules.archive.mk
MK                  += $(MK_$d)


#
#   Include Rules.mk for each subdir
#
SUB_$d           := $(abspath $(call filter-dir,$(call safe-paths,$d/)))
#SUB_$d           := $(call filter-dir,$(call safe-paths,$d/))
ILLEGAL          += $(call unsafe-paths,$d)
ifneq($(ILLEGAL),)
$(error Illegal Subdirs,$d,$(ILLEGAL$d))
endif
$(call chat,info,archive,Subdirs $d,$(SUB_$d))

SUB_MK_$d        := $(SUB_$d:%=$d/.build/%/Rules.archive.mk)
SUB_MK_NF_$d     := $(call complement,$(SUB_MK_$d),$(call filter-file,$(SUB_MK_$d)))
#$(info Submk,$(SUB_MK_$d))
#$(info Submk,$(call filter-file,$(SUB_MK_$d)))
#$(info Submkf,$(SUB_MK_NF_$d))
DMK_$d           := .build/$d/Rules.sub.mk
#$(info Dmk,$(DMK_$d))

# Generate Rules.sub.mk for each subdirectory
$(DMK_$d): MK_FILES := $(SUB_MK_$d)
$(DMK_$d): $(SUB_MK_NF_$d)
	@$(reset-target)
	@echo $(MK_FILES)|while read F; do\
	  DIR=$$(dirname $$F);\
	  $(ll) file_target "$@" "Adding include rule" "$$DIR $$F";\
	  if test ! -e "$$DIR"; then mkdir -p "$$DIR"; fi;\
	  echo "ifeq (\$$(shell if test -f \"$$F\"; then echo 1; fi),1)">>$@;\
	  echo "">>$@;\
	  echo "DIR := $${DIR#.build/}">>$@;\
	  echo "include $$F">>$@;\
	  echo "MK += $$F">>$@;\
	  echo "endif">>$@;\
	done;
	@$(ll) file_ok "$@"

include $(DMK_$d) 
MK += $(DMK_$d) 
# List dynamic makefiles
#DMK += $(DMK_$d) 


$d/.build/%/Rules.archive.mk: DIR := $d
$d/.build/%/Rules.archive.mk:
	@if test ! -d "$(@D)"; then mkdir -p $(@D); fi
	@cd $(@D); ln -s $(MK_$(DIR)) ./
	@$(ll) file_ok "$@"


#$(info )

## Pop from dirstack
d 				:= $(D_$(SP))
SP				:= $(basename $(SP))
# vim:noet:
