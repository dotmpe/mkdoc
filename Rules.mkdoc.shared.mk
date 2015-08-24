# Id: mkdoc/0.0.2-test+20150804-0404 Rules.mkdoc.shared.mk

test-mkdoc-specs: $(DIR) := $d
test-mkdoc-specs:
	@$(ll) attention $@ "Testing Core"
	@cd test/example/core/keywords;\
		bats ../../../mkdoc-core.bats
	@$(ll) attention $@ "Testing Du"
	@cd test/example/du/;\
		bats ../../mkdoc-du.bats


TEST += test-mkdoc-specs

