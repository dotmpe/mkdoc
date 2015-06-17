$(eval $(call module-header,Core,$(MK_SHARE)/Core/Rules.movelink.mk,Movelink))
#
#      ------------ -- 


SRC_PATH            ?= /src/

# Set defaults (set to own values before include)
RS_LS_$d            ?= $/resources.list
RS_SRC_DIR_$d       ?= /Resources
RS_DIR_$d           ?= $d
RS_SRC_LS_$d        ?= $(RS_LS_$d:$(RS_DIR_$d)/%.list=$B%-src.list)
RS_DIR_LS_$d        ?= $(RS_LS_$d:$(RS_DIR_$d)/%.list=$B%-dir.list)
RS_MK_$d            ?= $Brules.ml.mk
# be carefull not to distinguish by file or symlink, 
# this makefile will use the -type f and -type l params
RS_FIND_$d          ?= -maxdepth 1


#      ------------ -- 

$(RS_SRC_LS_$d):       $(RS_SRC_DIR_$d)/
	@$(build-res-index)
	@touch $@
$(RS_SRC_LS_$d):       $(MK_$d)
$(RS_SRC_LS_$d): XTR := $(RS_FIND_$d) -type f

$(RS_DIR_LS_$d):       $(RS_DIR_$d)/
	@$(build-res-index)
	@touch $@
$(RS_DIR_LS_$d):       $(MK_$d)
$(RS_DIR_LS_$d): XTR := $(RS_FIND_$d) -type f

$(RS_LS_$d):           $(RS_DIR_LS_$d) $(RS_SRC_LS_$d)
	@$(log-file-target-because-from)
	@TRGT_E=$$(echo $T | $(sed-escape));\
		SRC_E=$$(echo $S | $(sed-escape));\
		cat $L | sed "s/^$$TRGT_E/$$SRC_E/g" | $(filter-paths) | sort -u > $@
	@$(ll) file_ok $@ Done
$(RS_LS_$d):      T := $(RS_DIR_$d)
$(RS_LS_$d):      S := $(RS_SRC_DIR_$d)
$(RS_LS_$d):      L := $(RS_DIR_LS_$d) $(RS_SRC_LS_$d)
$(RS_LS_$d):      D := $d
$(RS_LS_$d):      B := $B
$(RS_LS_$d):           $(MK_$d) $(MK_SHARE)Core/Rules.movelink.mk

DEP                 += $(RS_LS_$d)

ifeq ($(call exists,$(RS_LS_$d)),)
	PENDING           += $(RS_LS_$d)
else
	ifneq ($(call newer-than,$(RS_LS_$d),$(MK_$d) $($RS_DIR_LS_$d) $(RS_SRC_LS_$d)),)
		PENDING         += $(RS_LS_$d)
	endif
endif

#      ------------ -- 

define move-and-link
	@[ -L "$<" ] && [ "$$(readlink $<)" != "$@" ] \
		&& $(ll) file_target $@ "does not match target of" "$<" \
		&& rm "$<";
	@if test ! -L "$<"; then \
		[ -d "$@" ] \
			&& $(ll) file_target "$@" "path exists and is directory" "$<"; \
		[ -e "$@" ] \
			&& $(ll) error "$@" "path exists" "$<"; \
		[ ! -f "$<" ] \
			&& $(ll) error "$@" "missing file for movelink" "$<"; \
		[ ! -d "$$(dirname $@)" ] \
		  && mkdir -p $$(dirname $@); \
		[ ! -e "$@" ] && [ -f "$<" ] \
			&& mv "$<" "$@" \
			&& ln -s "$@" "$<" \
			&& $(ll) file_ok $@ "<-movelink-" "$<" ; \
	fi
endef

SRC_PATH            := /src/

$(RS_MK_$d):           $(RS_LS_$d)
	@$(log-file-target-because-from)
	@$(reset-target)
	@resources=$$(cat $< | $(filter-paths));\
	SRCPATH="$(SRC_PATH)/";rl="$${#SRCPATH}";\
	for res in $$resources;\
	do \
		sub=$${res:$$rl};\
		[ -L "$$res" ] && [ "$$(readlink $$res)" != "$D$$sub" ] \
			&& rm $$res;\
		[ -L "$$res" ] \
			&& continue;\
		if test ! -e "$D$$sub"; then\
			echo "$D$$sub:: $$res" >> $@;\
			$(ee) "\t@\$$(log-file-target-because-from)" >> $@;\
			$(ee) "\t@\$$(ll) file_target \$$@ from \$$^ " >> $@;\
			$(ee) "\t@\$$(move-and-link)" >> $@;\
			$(ee) "\t@\$$(ll) file_ok \$$@ done" >> $@;\
			echo "SRC += $D$$sub" >> $@;\
		else if test -f "$D$$sub"; then \
			[ -d $$(dirname $$res) ] || mkdir -p $$(dirname $$res);\
			ln -s $$(cd $D; pwd -P)$$sub $$res;\
		fi;fi;\
	done;
	@touch $@;
	@$(ll) file_ok "$@" done
$(RS_MK_$d):      B := $B
$(RS_MK_$d):      D := $/
$(RS_MK_$d):           $(MK_$d) $(MK_SHARE)Core/Rules.movelink.mk

DMK                 += $(RS_MK_$d)

ifeq ($(call exists,$(RS_MK_$d)),)
	PENDING += $(RS_MK_$d)
else
	ifneq ($(call newer-than,$(RS_MK_$d),$(RS_LS_$d)),)
		PENDING         += $(RS_MK_$d)
	endif
endif

#      ------------ -- 


