MK               += $(MK_SHARE)/plotutils/Rules.default.mk
$(call log-module,"plotutils","GNU/plotutils default rules")

pic2plot_fontsize := 0.0175
pic2plot_bitmapsize := 570x570
pic2plot_pagesize := a4
pic2plot_flags := 

define plotutils-pic-to-svg
	$(ll) file_target $@ "Rendering diagram $* because" "$?"
	$(reset-target)
	T=$$(realpath $@);cd $(<D);\
	 pic2plot -Tsvg $(<F) \
	 --page-size $(pic2plot_pagesize) \
	 --font-size $(pic2plot_fontsize) \
	 $(pic2plot_flags) \
	 --portable-output > $$T
	$(ll) info "$@" "`file -bs $@`"
	$(ll) file_ok $@ Done
endef

define plotutils-pic-to-png
	$(ll) file_target $@ "Rendering diagram $* because" "$?"
	$(reset-target)
	T=$$(realpath $@);cd $(<D);\
	 pic2plot -Tpng $(<F) \
	 --page-size $(pic2plot_pagesize) \
	 --font-size $(pic2plot_fontsize) \
	 --bitmap-size $(pic2plot_bitmapsize) \
	 $(pic2plot_flags) \
	 --portable-output > $$T
	$(ll) info "$@" "`file -bs $@`"
	$(ll) file_ok $@ Done
endef

define plotutils-pic-to-ps
	$(ll) file_target $@ "Rendering diagram $* because" "$?"
	$(reset-target)
	T=$$(realpath $@);cd $(<D);\
	 pic2plot -Tps $(<F) \
	 --page-size $(pic2plot_pagesize) \
	 --font-size $(pic2plot_fontsize) \
	 --bitmap-size $(pic2plot_bitmapsize) \
	 $(pic2plot_flags) \
	 --portable-output > $$T
	$(ll) info "$@" "`file -bs $@`"
	$(ll) file_ok $@ Done
endef


#      ------------ -- 

%.ps:                 %.pic
	@$(plotutils-pic-to-ps)

$(BUILD)%.ps:         %.pic
	@$(plotutils-pic-to-ps)


%.svg:                 %.pic
	@$(plotutils-pic-to-svg)

$(BUILD)%.svg:         %.pic
	@$(plotutils-pic-to-svg)


%.png:                 %.pic
	@$(plotutils-pic-to-png)

$(BUILD)%.png:         %.pic
	@$(plotutils-pic-to-png)

