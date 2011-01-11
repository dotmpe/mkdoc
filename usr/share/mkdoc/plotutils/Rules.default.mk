MK               += $(MK_SHARE)/docutils/Rules.default.mk

pic2plot_fontsize := 0.0175
pic2plot_bitmapsize := 570x570

define plotutils-pic-to-svg
	$(ll) file_target $@ "Rendering diagram $* because" "$?"
	$(reset-target)
	T=$$(realpath $@);cd $(<D);\
	 pic2plot -Tsvg $(<F) \
	 --portable-output > $$T
	$(ll) info "$@" "`file -bs $@`"
	$(ll) file_ok $@ Done
endef

define plotutils-pic-to-png
	$(ll) file_target $@ "Rendering diagram $* because" "$?"
	$(reset-target)
	T=$$(realpath $@);cd $(<D);\
	 pic2plot -Tpng $(<F) \
	 --font-size $(pic2plot_fontsize) \
	 --bitmap-size $(pic2plot_bitmapsize) \
	 --portable-output > $$T
	$(ll) info "$@" "`file -bs $@`"
	$(ll) file_ok $@ Done
endef

%.svg:      %.pic
	@$(plotutils-pic-to-svg)

$(BUILD)%.svg:      %.pic
	@$(plotutils-pic-to-svg)

%.png:      %.pic
	@$(plotutils-pic-to-png)

$(BUILD)%.png:      %.pic
	@$(plotutils-pic-to-png)

