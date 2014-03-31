ifeq ($(MAKECMDGOALS),info)
#$(info $(shell $(ll) info Core/Main.dirstack-pop "Loaded - $d $/ $(call location)" "$(MK_$d)"))
#else
$(call chat,info,$/,Loaded,$(MK_$d))
endif
## Pop from dirstack
d 				:= $(D_$(SP))
/				:= $d/
SP				:= $(basename $(SP))
# vim:noet:
