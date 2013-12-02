ifeq ($(MAKECMDGOALS),info)
$(info $(shell $(ll) info dirstack-pop Loaded $(MK_$d)))
else
$(call chat,info,"dirstack-pop",Loaded,$(MK_$d))
endif
## Pop from dirstack
d 				:= $(D_$(SP))
/				:= $d/
SP				:= $(basename $(SP))
# vim:noet:
