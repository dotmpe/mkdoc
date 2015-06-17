$(eval $(call module-header,Core,$(MK_SHARE)Core/Rules.project.mk,))
#
#      ------------ -- 



define tag_list
	OPTS="-srI"; \
	FLAGS=""; \
	[ -n "$X" ] && { for exclude in "$X"; do FLAGS="$$FLAGS --exclude=$$exclude"; done }; \
	echo -n > $@; \
	for tag in $T; do \
		$(ll) info $@ "Scanning for $$tag" "$(S)"; \
		grep $$OPTS $$tag $$FLAGS $S >> $@; \
	done; \
	$(ll) info $@ "Done" "$(S)"; \
	mv -v $@ $@.tmp; sort -u $@.tmp > $@; \
	wc -l $@; rm $@.tmp
endef

