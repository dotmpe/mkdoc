ifneq ($(MK_$d),)
$(info $(shell $(ll) file_ok "$(MK_$d)" "Loaded"))
else
$(info $(shell $(ll) file_ok "$/" "Loaded"))
endif
## Pop from dirstack
d 				:= $(D_$(SP))
/ 				:= $d/
SP				:= $(basename $(SP))
# vim:noet:
