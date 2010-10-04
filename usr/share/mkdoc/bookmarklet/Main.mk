
js2bm               = $(MK_SHARE)bookmarklet/js2bm.pl
js2bm-debug         = $(MK_SHARE)bookmarklet/js2bm.pl -d


define build-bm
	$(ee) "javascript:void((function(){"`cat $^`"})())" > $@.tmp
	$(js2bm) $@.tmp > $@
	rm $@.tmp
endef

define build-bm-rst
	$(ee) -n ".. _"$*".bm: " > $@
	cat $< >> $@
	$(ee) >> $@
endef

