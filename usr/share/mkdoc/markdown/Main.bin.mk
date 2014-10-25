$(eval $(call module-header,markdown,$(MK_SHARE)markdown/Main.bin.mk,"GNU/markdown binaries"))
#
#      ------------ -- 

MD_GEN :=

ifneq ($(shell which markdown),)
md-html = markdown $(MD_GEN)
endif

ifeq ($(md-html),)
$(call chat,warn,markdown,Missing Markdown convertor)
endif

