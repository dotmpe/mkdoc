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
#$(BUILD)%.rst:      %.rst
#	@echo 'in' $?
#	@echo 'out' $@
#	@$(ll) file_target "$@" because "$?"
#	$(if $(call is-file,$(shell $(kwds-file))),
#		$(ante-proc-tags),
#		$(shell cp $< $<.src))
#	@mv $<.src $@	
#	@$(ll) file_ok "$@" Done


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


%,du.xml:                    %.rst
	@$(ll) file_target "$@" because "$?"
	@$(reset-target)
	@T=$$(realpath $@);cd $(<D);$(rst-xml) $(<F) $$T
	@$(ll) file_ok "$@" Done


#$(BUILD)%,du-newlatex.latex: %.rst
#	@$(ll) file_target "$@" because "$?"
#	@$(reset-target)
#	@T=$$(realpath $@);cd $(<D);$(rst-newlatex) $(<F) $$T
#	@$(ll) file_ok "$@" Done

$(BUILD)%,du.latex: %.rst
	$(rst-to-latex)

$(BUILD)%,du.odt: %.rst
	@$(ll) file_target "$@" because "$?"
	@$(reset-target)
	@T=$$(realpath $@);cd $(<D);$(rst-odt) $(<F) $$T
	@$(ll) file_ok "$@" Done


$(BUILD)%,du.pxml: %.rst
	@$(ll) file_target "$@" because "$?"
	@$(reset-target)
	@T=$$(realpath $@);cd $(<D);$(rst-pseudoxml) $(<F) $$T
	@$(ll) file_ok "$@" Done



# rst2gxl by S. Merten
# XXX: it seems internal or local references are mapped to edges
# not external links or includes
$(BUILD)%,du.gxl: %.rst
	@$(ll) file_target "$@" because "$?"
	@# XXX: wrong attr. name:
	@rst2gxl.py $< | sed 's/name=\"name\"/name="label"/g' > $@
	@$(tidy-xml) $@
	@$(ll) file_ok "$@" Done

%,du.gxl: %.rst
	@$(ll) file_target "$@" because "$?"
	@rst2gxl.py $< | sed 's/name=\"name\"/name="label"/g' > $@
	@$(tidy-xml) $@
	@$(ll) file_ok "$@" Done

