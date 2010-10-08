## Dirstack
SP                  := $(SP).x
D_$(SP)             := $d
d                   := $(DIR)

MK                  += $d/Rules.mk


## Pop from dirstack
d 				:= $(D_$(SP))
SP				:= $(basename $(SP))
# vim:noet:

