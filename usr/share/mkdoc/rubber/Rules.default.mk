
%.latex.pdf: %.latex
	@$(ll) file_target "$@" because "$?"
	@rubber --inplace --pdf $<
	@rubber --inplace --clean $<
	@$(ll) file_ok "$@" Done

