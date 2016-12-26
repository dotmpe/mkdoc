# Id: mkdoc/0.0.2-test+20150804-0404 Rules.mkdoc.shared.mk

.PHONY: test-mkdoc-specs

test-mkdoc-specs:: DIR := $(shell dirname $(location))
test-mkdoc-specs::
	@$(ll) attention $@ "Testing Core"
	@cd $(DIR)/test/example/core/keywords;\
		bats ../../../mkdoc-core.bats
	@$(ll) attention $@ "Testing Du"
	@cd $(DIR)/test/example/du/;\
		bats ../../mkdoc-du.bats
	@$(ll) attention $@ "Testing Make"
	@cd $(DIR)/test/example/du/;\
		bats ../../mkdoc-make.bats
	@$(ll) attention $@ "Testing BM"
	@export MK_DIR=$(DIR); cd $(DIR)/test/example/du/;\
		bats ../../mkdoc-bm.bats
	@$(ll) ok $@ "specs for Core, Du, Make and BM"


TEST += test-mkdoc-specs

