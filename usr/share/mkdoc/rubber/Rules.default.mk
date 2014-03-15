## 
MK_$d               += $(MK_SHARE)/rubber/Rules.default.mk
include                $(MK_SHARE)Core/Main.makefiles.mk
#
#      ------------ -- 

#$(call log-module,rubber,Rubber (LaTeX to PDF) default rules)

$(if $(shell which rubber),,$(info $(shell \
	$(ll) "warning" rubber "rubber convertor not available")))


%,rubber-latex.pdf:        %.latex
	@$(ll) file_target "$@" because "$?"
	@if test -n "$(DIR)"; then D=$(@D);else D=$(DIR);fi;\
	 cd $$D;\
	 rubber --inplace --pdf $(<F);\
	 rubber --inplace --clean $(<F)
	@mv $(<D)/$$(basename $< .latex).pdf $@
	@$(info-bin-stat)
	@$(ll) file_ok "$@" Done

