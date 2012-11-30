$(call chat,info,"$/",Loaded,$(MK_$d))
## Pop from dirstack
d 				:= $(D_$(SP))
/ 				:= $d/
SP				:= $(basename $(SP))
# vim:noet:
