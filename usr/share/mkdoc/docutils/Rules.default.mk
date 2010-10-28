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


$(BUILD)%.xhtml:				%.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-to-xhtml)
	@$(target-stats)
	@$(ll) file_ok "$@" Done


%.xhtml:				        %.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-to-xhtml)
	@$(target-stats)
	@$(ll) file_ok "$@" Done


%.xml: %.rst
	@$(ll) file_target "$@" because "$?"
	@rst2xml $(DU_GEN) $(DU_READ) $(DU_XML) $< $@
	@$(ll) file_ok "$@" Done
	
%.tex: %.rst
	@$(ll) file_target "$@" because "$?"
	@rst2latex $(DU_GEN) $(DU_READ) $(DU_LATEX) $< $@
	@$(ll) file_ok "$@" Done

%.odt: %.rst
	@$(ll) file_target "$@" because "$?"
	@rst2odt $(DU_GEN) $(DU_READ) $(DU_ODT) $< $@
	@$(ll) file_ok "$@" Done

