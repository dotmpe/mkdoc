## Pop from dirstack
d 				:= $(D_$(SP))
/ 				:= $d/
SP				:= $(basename $(SP))
# vim:noet:
