# Id: mkdoc/0.0.2-test+20150804-0404 Rules.mkdoc.shared.mk

.PHONY: test-mkdoc-specs

test-mkdoc-specs:: DIR := $(shell dirname $(location))
test-mkdoc-specs:: PREFIX := $(DIR)/usr
test-mkdoc-specs:: MK_SHARE := $(DIR)/usr/share/mkdoc/
test-mkdoc-specs::
	@echo "DIR = $(DIR)"
	@echo "PREFIX = $(PREFIX) $(origin PREFIX)"
	@echo "location = $(location) $(origin location)"
	@echo "MK_SHARE = $(MK_SHARE) $(origin MK_SHARE)"
	@$(ll) attention $@ "Testing Core"
	@cd $(DIR)/test/example/core/keywords; \
		export PREFIX=$(PREFIX) MK_SHARE=$(MK_SHARE); \
		bats ../../../mkdoc-core.bats
	@$(ll) attention $@ "Testing Du"
	@cd $(DIR)/test/example/du/;\
		export PREFIX=$(PREFIX) MK_SHARE=$(MK_SHARE); \
		bats ../../mkdoc-du.bats
	@$(ll) attention $@ "Testing Make"
	@cd $(DIR)/test/example/du/;\
		export PREFIX=$(PREFIX) MK_SHARE=$(MK_SHARE); \
		bats ../../mkdoc-make.bats
	@$(ll) attention $@ "Testing BM"
	@export MK_DIR=$(DIR); cd $(DIR)/test/example/du/;\
		export PREFIX=$(PREFIX) MK_SHARE=$(MK_SHARE); \
		bats ../../mkdoc-bm.bats
	@$(ll) ok $@ "specs for Core, Du, Make and BM"


TEST += test-mkdoc-specs

