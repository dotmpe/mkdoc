MK               += $(MK_SHARE)/docutils/Rules.default.mk


%.include.mk:       %.rst 
	@$(ll) file_target $@ "Creating XHTML dependencies for $* from" "$<"
	@$(reset-target)
	@$(mk-rst-include-deps)
	@$(ll) file_ok $@ Done

$(BUILD)%.include.mk: %.rst 
	@$(ll) file_target $@ "Creating XHTML dependencies for $* from" "$<"
	@$(reset-target)
	@$(mk-rst-include-deps)
	@$(ll) file_ok $@ Done


# TODO: step to .src instead
$(BUILD)%.rst:      %.rst
	@$(ll) file_target "$@" because "$?"
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ante-proc-tags),
		$(shell cp $< $<.src))
	@mv $<.src $@	
	@$(ll) file_ok "$@" Done


%.xhtml:			%.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-to-xhtml)
	@$(target-stats)
	@$(ll) file_ok "$@" Done

$(BUILD)%.xhtml:	%.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-to-xhtml)
	@$(target-stats)
	@$(ll) file_ok "$@" Done


%.xml: %.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-xml) $< $@
	@$(ll) file_ok "$@" Done


$(BUILD)%,newlatex.latex: %.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-newlatex)  $< $@
	@$(ll) file_ok "$@" Done

$(BUILD)%.latex: %.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-latex)  $< $@
	@$(ll) file_ok "$@" Done


$(BUILD)%.odt: %.rst
	@$(ll) file_target "$@" because "$?"
	@$(rst-odt) $< $@
	@$(ll) file_ok "$@" Done



