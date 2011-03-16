MK               += $(MK_SHARE)/docutils/Rules.default.mk
$(call log-module,"docutils","Docutils default rules")


%.include.mk:           %.rst 
	@$(ll) file_target $@ "Creating XHTML dependencies for $* from" "$<"
	@$(reset-target)
	@$(mk-rst-include-deps)
	@$(info-text-stat)
	@$(ll) file_ok $@ Done

$(BUILD)%.include.mk:   %.rst 
	@$(ll) file_target $@ "Creating XHTML dependencies for $* from" "$<"
	@$(reset-target)
	@$(mk-rst-include-deps)
	@$(info-text-stat)
	@$(ll) file_ok $@ Done


# TODO: step to .src instead
#$(BUILD)%.rst:        %.rst
#	@echo 'in' $?
#	@echo 'out' $@
#	@$(ll) file_target "$@" because "$?"
#	$(if $(call is-file,$(shell $(kwds-file))),
#		$(ante-proc-tags),
#		$(shell cp $< $<.src))
#	@mv $<.src $@	
#	@$(ll) file_ok "$@" Done


# TODO: rename this to ,du
#%.xhtml:			     %.rst
#	@$(ll) file_target "$@" "to directory because" "$?"
#	@$(rst-to-xhtml)
#	@$(info-text-stat)
#	@$(ll) file_ok "$@" Done

$(BUILD)%.xhtml:	     %.rst
	@$(ll) file_target "$@" "to BUILD because" "$^"
	@$(ll) file_target "$@" "to BUILD because" "$?"
	@$(rst-to-xhtml)
	@$(info-text-stat)
	@$(ll) file_ok "$@" Done


%,du.xml:              %.rst
	@$(ll) file_target "$@" because "$?"
	@$(reset-target)
	@T=$$(realpath $@);cd $(<D);$(rst-xml) $(<F) $$T
	@$(info-text-stat)
	@$(ll) file_ok "$@" Done

$(BUILD)%,du.xml:      %.rst
	@$(ll) file_target "$@" because "$?"
	@$(reset-target)
	@T=$$(realpath $@);cd $(<D);$(rst-xml) $(<F) $$T
	@$(info-text-stat)
	@$(ll) file_ok "$@" Done


#$(BUILD)%,du-newlatex.latex: %.rst
#	@$(ll) file_target "$@" because "$?"
#	@$(reset-target)
#	@T=$$(realpath $@);cd $(<D);$(rst-newlatex) $(<F) $$T
#	@$(ll) file_ok "$@" Done

$(BUILD)%,du.latex:    %.rst
	@$(rst-to-latex)

$(BUILD)%,du.odt:      %.rst
	@$(ll) file_target "$@" because "$?"
	@$(reset-target)
	@T=$$(realpath $@);cd $(<D);$(rst-odt) $(<F) $$T
	@$(info-target-stats)
	@$(ll) file_ok "$@" Done


$(BUILD)%,du.pxml:     %.rst
	@$(rst-to-pseudoxml)



define rst-to-s5
	$(ll) file_target "$@" because "$?"
	$(reset-target)
	T=$$(realpath $@);cd $(<D);$(rst-s5) $(<F) $$T;\
		mv $$T $$T.tmp;\
		echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">' > $$T;\
		tail -n +3 $$T.tmp >> $$T; rm $$T.tmp
	$(info-target-stats)
	$(ll) file_ok "$@" Done
endef

%,du,s5.html:      %.rst
	@$(rst-to-s5)

$(BUILD)%,du,s5.html:      %.rst
	@$(rst-to-s5)


# rst2gxl by S. Merten
# XXX: it seems internal or local references are mapped to edges
# not external links or includes
$(BUILD)%,du.gxl:      %.rst
	@$(ll) file_target "$@" because "$?"
	@# XXX: wrong attr. name:
	@rst2gxl.py $< | sed 's/name=\"name\"/name="label"/g' > $@
	@$(tidy-xml) $@
	@$(info-text-stat)
	@$(ll) file_ok "$@" Done

%,du.gxl:              %.rst
	@$(ll) file_target "$@" because "$?"
	@rst2gxl.py $< | sed 's/name=\"name\"/name="label"/g' > $@
	@$(tidy-xml) $@
	@$(info-text-stat)
	@$(ll) file_ok "$@" Done

# 1    ------------ -- 

