MK               += $(MK_SHARE)/plotutils/Main.mk
$(call log-module,plotutils,)

BIN              += pic2plot=$(shell which pic2plot)

$(if $(shell $(call get-bin,hg)),,$(info $(shell \
	$(ll) "warning" plotutils "missing pic2plot convertor, install GNU/plotutils")))

# http://www.gnu.org/software/plotutils/plotutils.html
