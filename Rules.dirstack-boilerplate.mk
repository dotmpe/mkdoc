include                $(MK_SHARE)Core/Main.dirstack.mk
MK_$d               := $/Rules.mk
MK                  += $(MK_$d)
#
#      ------------ -- 

#
#DIR                 := $/mydir
#include                $(call rules,$(DIR)/)
#
# DMK += $/dynamic-makefile.mk
# DEP += $/generated-dependency
# TRGT += $/build-target
# CLN += $/tmpfile
# TEST += $/testtarget


STRGT += example
example::
	@$(log-file-target-because-from)

#      ------------ -- 
#
include                $(MK_SHARE)Core/Main.dirstack-pop.mk
# vim:noet:
