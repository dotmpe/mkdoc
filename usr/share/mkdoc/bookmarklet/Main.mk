$(eval $(call module-header,bookmarklet,$(MK_SHARE)bookmarklet/Main.mk,"Javascript bookmarklets"))
#
#      ------------ -- 


js2bm               = $(MK_SHARE)bookmarklet/js2bm.pl
js2bm-debug         = $(MK_SHARE)bookmarklet/js2bm.pl -d


define build-bm
	$(ll) file_target $@ "Building from" "$<";
	$(reset-target)
    JS=$$(cat $<);\
	$(ee) "javascript:void((function(){$$JS})())" > $@.tmp
	$(js2bm) $@.tmp > $@
	rm $@.tmp
endef

define build-bm-rst
	RES="$*";\
	REFID=$${RES##$(@D)/};\
	$(ll) file_target $@ "Building $$REFID from" "$<";\
	$(ee) -n ".. _$$REFID.bm: " > $@
	cat $< >> $@
	$(ee) >> $@
endef

