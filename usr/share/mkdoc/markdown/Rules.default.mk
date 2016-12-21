$(eval $(call module-header,markdown,$(MK_SHARE)markdown/Rules.default.mk,'Markdown default rules'))
#
#      ------------ -- 

ifneq ($(md-html),)

$(BUILD)%.xhtml:	           $/%.md
	@$(log-file-target-because-from)
	@$(reset-target)
	@$(if $(call is-file,$(shell $(kwds-file))),\
		$(ll) info "source tags" "Expanding keywords tags from " $$($(kwds-file));\
		$(ante-proc-tags))
	@#echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' >> $@
	@echo "<html>"  >> $@
	@echo "<head><title></title></head>"  >> $@
	@echo "<body>"  >> $@
	@$(md-html) $<.src >> $@
	@echo "</body></html>"  >> $@
	@$(info-text-stat)
	@$(ll) file_ok "$@" Done


endif

