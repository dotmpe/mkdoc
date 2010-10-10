MK               += $(MK_SHARE)/docutils/Rules.default.mk


%.include.mk: %.rst 
	@$(ll) file_target $@ "Creating XHTML dependencies for $* from" "$<"
	@$(reset-target)
	@$(mk-rst-include-deps)
	@$(ll) file_ok $@ Done

$(BUILD)%.include.mk: %.rst 
	@$(ll) file_target $@ "Creating XHTML dependencies for $* from" "$<"
	@$(reset-target)
	@$(mk-rst-include-deps)
	@$(ll) file_ok $@ Done


%.xhtml:				        %.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-to-xhtml)
	@$(target-stats)
	@$(ll) file_ok "$@" Done

$(BUILD)%.xhtml:				%.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-to-xhtml)
	@$(target-stats)
	@$(ll) file_ok "$@" Done


