
# A bash script to invoke python tests
test-python          =\
	 if test -n "$(shell which python)"; then \
		$(ll) info "$$TEST_PY" "Testing Python sources.."; \
		\
		if test -n "$(shell which python-coverage)"; \
		then \
			RUN="python-coverage -x test/py/main.py "; \
		fi; \
		if test -n "$(shell which coverage)"; \
		then \
			RUN="coverage run "; \
			if test -n "$$TEST_LIB";\
			then\
				RUN=$$RUN" --source="$$TEST_LIB;\
			fi;\
		fi; \
		if test -z "$$RUN"; then \
			$(call chatty,1,warn,$@,Coverage for python not available); \
			RUN=python;\
		fi; \
		\
		$(call chatty,2,attention,$$,$$RUN,$$TEST_PY);\
		$$RUN $$TEST_PY; \
		$(call chatty,2,header,exit-status,$$?);\
		$(call zero_exit_test,$$?,$@,Python tested,Python testing failed); \
		\
		if test -n "$(shell which coverage)"; \
		then \
			coverage html; \
			$(call chatty,0,file_OK,htmlcov/,Generated test coverage report in HTML); \
		fi; \
	else \
		$(ll) error "$@" "Tests require Python interpreter. "; \
	fi


