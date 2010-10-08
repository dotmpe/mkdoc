MK               += $(MK_SHARE)/docutils/Rules.default.mk


%.xhtml:				        %.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-to-xhtml)
	@$(target-stats)
	@$(ll) file_ok "$@"

$(BUILD)/%.xhtml:				%.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-to-xhtml)
	@$(target-stats)
	@$(ll) file_ok "$@"

