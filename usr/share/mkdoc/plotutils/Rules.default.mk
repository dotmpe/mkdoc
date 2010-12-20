MK               += $(MK_SHARE)/docutils/Rules.default.mk

pic2plot_fontsize := 0.01

$(BUILD)%.png:      %.pic
	@$(ll) file_target $@ "Rendering diagram $* because" "$?"
	@$(reset-target)
	@T=$$(realpath $@);cd $(<D);\
		pic2plot -Tpng $(<F) \
		--portable-output > $$T
	@$(ll) info "$@" "`file -bs $@`"
	@$(ll) file_ok $@ Done


$(BUILD)%.svg:      %.pic
	@$(ll) file_target $@ "Rendering diagram $* because" "$?"
	@$(reset-target)
	@T=$$(realpath $@);cd $(<D);\
		pic2plot -Tsvg $(<F) \
		--portable-output > $$T
	@$(ll) info "$@" "`file -bs $@`"
	@$(ll) file_ok $@ Done


