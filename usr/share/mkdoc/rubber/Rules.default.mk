
%,latex.pdf:        %.latex
	@$(ll) file_target "$@" because "$?"
	@if test -n "$(DIR)"; then D=$(@D);else D=$(DIR);fi;\
	 cd $$D;\
	 rubber --inplace --pdf $(<F);\
	 rubber --inplace --clean $(<F)
	@mv $(<D)/$$(basename $< .latex).pdf $@
	@$(info-bin-stat)
	@$(ll) file_ok "$@" Done

