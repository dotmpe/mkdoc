
%,latex.pdf:        %.latex
	@$(ll) file_target "$@" because "$?"
	@rubber --inplace --pdf $<
	@rubber --inplace --clean $<
	@mv $(<D)/$$(basename $< .latex).pdf $@
	@$(ll) file_ok "$@" Done

