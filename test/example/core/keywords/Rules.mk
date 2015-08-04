
BUILD_$d            := $/$(BUILD)
KWDS_$d             := $/KEYWORDS


TAG_$d         := abc-1234

$(KWDS_$d): DIR := $d
$(KWDS_$d):  $d/Rules.mk
	@$(ll) file_target "$@" "Building tagfile because" "$?"
	@$(reset-target)
	@$(ll) header2 $@ '' DIR=$(DIR)
	@echo -e 'TAG\t$(TAG_$(DIR))' >> $@
	@echo -e 'MK_BUILD\t$(BUILD_$(DIR))' >> $@
	@$(ll) file_OK $@


DEP += $(KWDS_$d)

STRGT += test-ante-proc-tags
TEST += test-ante-proc-tags

test-ante-proc-tags: $/test.file.src
	md5sum -c check.md5

TRGT += $/test.file.src
CLN += $/test.file.src

$/%.file.src: $/%.file  $/Rules.mk
	@$(log-file-target-because-from)
	@$(if $(call is-file,$(shell $(kwds-file))),\
		$(ante-proc-tags),\
		$(shell cp $< $<.src))


