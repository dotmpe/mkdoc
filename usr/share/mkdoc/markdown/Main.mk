$(eval $(call module-header,markdown,$(MK_SHARE)markdown/Main.mk,Markdown formatted docs))
#
#      ------------ -- 

include             $(MK_SHARE)/markdown/Main.bin.mk

define md-to-xhtml
	$(md-html) $^ > $@
endef
