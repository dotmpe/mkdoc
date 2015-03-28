$(eval $(call module-header,plotutils,$(MK_SHARE)plotutils/Main.mk,"GNU/plotutils"))
#
#      ------------ -- 


BIN              += pic2plot=$(shell which pic2plot)

$(if $(call get-bin,pic2plot),,$(info $(shell \
	$(ll) "warning" plotutils "missing pic2plot convertor, install GNU/plotutils")))

# http://www.gnu.org/software/plotutils/plotutils.html
