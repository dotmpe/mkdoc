# Id: mkdoc/0.0.2-devel Rules.dirstack-boilerplate.mk
include                $(MK_SHARE)Core/Main.dirstack.mk
MK_$d               := $/Rules.mk
MK                  += $(MK_$d)
#
#      ------------ -- 


include                $(MK_SHARE)Core/Rules.project.mk

$/TODO.list: S = $/etc $/usr $/var $(wildcard $/*.mk $/*.rst)
$/TODO.list: T = TODO XXX FIXME
$/TODO.list: X = TODO.list 
$/TODO.list: $(S)
	@\
	$(ll) file_target "$@" because "$?";\
	$(tag_list);\
	$(ll) file_OK $@


#
#DIR                 := $/mydir
#include                $(call rules,$(DIR)/)
#
# DMK += $/dynamic-makefile.mk
# DEP += $/generated-dependency
# TRGT += $/build-target
# CLN += $/tmpfile
# TEST += $/testtarget

#      ------------ -- 
#
include                $(MK_SHARE)Core/Main.dirstack-pop.mk
# vim:noet:
