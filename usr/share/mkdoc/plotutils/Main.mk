## 
MK_$d               += $(MK_SHARE)/plotutils/Main.mk
include                $(MK_SHARE)Core/Main.makefiles.mk
#
#      ------------ -- 

#$(call log-module,plotutils,)

BIN              += pic2plot=$(shell which pic2plot)

$(if $(shell $(call get-bin,pic2plot)),,$(info $(shell \
	$(ll) "warning" plotutils "missing pic2plot convertor, install GNU/plotutils")))

# http://www.gnu.org/software/plotutils/plotutils.html
