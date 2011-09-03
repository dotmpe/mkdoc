include                $(MK_SHARE)Core/Main.dirstack.mk
MK_$d               := $/Rules.mk
MK                  += $(MK_$d)
#
#      ------------ -- 

#
#DIR                 := $/mydir
#include                $(call rules,$(DIR)/)


#      ------------ -- 
#
include                $(MK_SHARE)Core/Main.dirstack-pop.mk
# vim:noet:
