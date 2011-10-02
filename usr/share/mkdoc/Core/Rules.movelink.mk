# Set defaults (set to own values before include)
RS_LS_$d            ?= $/resources.list
RS_SRC_LS_$d        ?= $(RS_LS_$d:$(RS_DIR_$d)%.list=$B%-src.list)
RS_DIR_LS_$d        ?= $(RS_LS_$d:$(RS_DIR_$d)%.list=$B%-dir.list)
RS_MK_$d            ?= $Brules.ml.mk
# be carefull not to distinguish by file or symlink, 
# this makefile will use the -type f and -type l params
RS_FIND_$d          ?= -maxdepth 1
RS_DIR_$d           ?= /Resources/


#      ------------ -- 

$(RS_SRC_LS_$d):       $(RS_SRC_DIR_$d)
	@$(build-res-index)
	@touch $@
	@$(ll) file_ok $@ done
$(RS_SRC_LS_$d):       $(MK_$d)
$(RS_SRC_LS_$d): XTR := $(RS_FIND_$d) -type f

$(RS_DIR_LS_$d):       $(RS_DIR_$d)
	@$(build-res-index)
	@touch $@
	@$(ll) file_ok $@ done
$(RS_DIR_LS_$d):       $(MK_$d)
$(RS_DIR_LS_$d): XTR := $(RS_FIND_$d) -type f

$(RS_LS_$d):           $(RS_DIR_LS_$d) $(RS_SRC_LS_$d)
	@$(ll) file_target $@ because $?
	TRGT_E=$$(echo $T | $(escape));\
	SRC_E=$$(echo $S | $(escape));\
	cat $^ | sed 's/^$$TRGT_E/$$SRC_E/' | $(filter-paths) > $@.tmp
	cat $@.tmp | sort -u > $@
	rm $@.tmp
	@$(ll) file_ok $@ done
$(RS_LS_$d):      T := $(RS_DIR_$d)
$(RS_LS_$d):      S := $(RS_SRC_DIR_$d)
$(RS_LS_$d):      D := $d
$(RS_LS_$d):      B := $B

DEP                 += $(RS_LS_$d)

ifeq ($(call exists,$(RS_LS_$d)),)
	PENDING           += $(RS_LS_$d)
else
	ifeq ($(call older,$(RS_LS_$d),$(SRC_PATH)) $(MK_$d) $($RS_DIR_LS_$d) $(RS_SRC_LS_$d)),)
		PENDING         += $(RS_LS_$d)
	else
	 RES_$d          := $(shell cat $(RS_LS_$d) | $(filter-paths))
	endif
endif

#      ------------ -- 

$(RS_MK_$d):           $(RS_LS_$d)
	@$(ll) file_target "$@" 
	@$(reset-target)
	@resources=$$(cat $< | $(filter-paths));\
	SRCPATH=$(SRC_PATH);rl="$${#SRCPATH}";\
	for res in $$resources;\
	do \
		sub=$${res:$$rl};\
		if [ -f $$D$$sub ];\
			[ -L $$res ] && continue;\
			ln -s $$D$$sub $$res;\
			continue;
		fi;\
		echo "$D$$sub: $$res" >> $@;\
		echo -e "\t@\$$(ll) file_target \$$@" >> $@;\
		echo -e "\t@\$$(call init-dir,\$$(@D))" >> $@;\
		echo -e "\t@\$$(ll) file_ok \$$@ done" >> $@;\
		echo "SRC += $D$$sub" >> $@;\
	done;
	@$(ll) file_ok "$@" done
$(RS_MK_$d):      B := $B
$(RS_MK_$d):      D := $/
$(RS_MK_$d):           $(MK_$d) $(MK_SHARE)Core/Rules.movelink.mk
$(RS_MK_$d):           $(RS_LS_$d)

DMK                 += $(RS_MK_$d)

ifeq ($(call exists,$(RS_MK_$d)),)
	PENDING += $(RS_MK_$d)
endif

#      ------------ -- 


