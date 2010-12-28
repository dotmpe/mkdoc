

%.bm.uriref: %.js
	@$(ll) file_target $@ "Because" "$?"
	@$(build-bm)
	@$(info-text-stat)
	@$(ll) file_ok $@ Done

$B%.bm.uriref: %.js
	@$(ll) file_target $@ "Because" "$?"
	@$(build-bm)
	@$(info-text-stat)
	@$(ll) file_ok $@ Done


%.bm.rst: %.bm.uriref
	@$(ll) file_target $@ "Because" "$?"
	@$(build-bm-rst)
	@$(info-text-stat)
	@$(ll) file_ok $@ Done

$B%.bm.rst: %.bm.uriref
	@$(ll) file_target $@ "Because" "$?"
	@$(build-bm-rst)
	@$(info-text-stat)
	@$(ll) file_ok $@ Done


