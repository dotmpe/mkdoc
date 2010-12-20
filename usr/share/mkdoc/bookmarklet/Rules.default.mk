

%.bm.uriref: %.js
	@$(ll) file_target $@ "Because" "$?"
	@$(build-bm)
	@$(ll) file_ok $@ Done

$B%.bm.uriref: %.js
	@$(ll) file_target $@ "Because" "$?"
	@$(build-bm)
	@$(ll) file_ok $@ Done


%.bm.rst: %.bm.uriref
	@$(ll) file_target $@ "Because" "$?"
	@$(build-bm-rst)
	@$(ll) file_ok $@ Done

$B%.bm.rst: %.bm.uriref
	@$(ll) file_target $@ "Because" "$?"
	@$(build-bm-rst)
	@$(ll) file_ok $@ Done


