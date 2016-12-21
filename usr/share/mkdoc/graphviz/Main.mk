$(eval $(call module-header,graphviz,$(MK_SHARE)graphviz/Rules.default.mk,Graphviz graph rendering))
#
#      ------------ -- 

ifneq ($(shell which dot),)
gv-dot = dot $(DOT)
GV_VERSION = $(gv-dot) --version
endif

ifneq ($(GV_VERSION),)
$(eval $(foreach FE,dot twopi circo fdp neato,\
	$(if $(shell which $(FE)),,$(info $(shell \
		$(ll) "warning" graphviz "Graphviz '$(FE)' frontend not available")))))
$(if $(shell which gxl2gv),,$(info $(shell \
	$(ll) "warning" graphviz "gxl2gv convertor not available")))

GRAPHVIZ_ENGINE     := dot
#values: dot,twopi,circo,fdp,neato
GRAPHVIZ_FLAGS      := -Gsplines=true 
GRAPHVIZ_OUT        := 

#      ------------ -- 

define gv-graph
	$(reset-target)
	$(GRAPHVIZ_ENGINE) $(GRAPHVIZ_FLAGS) -T$(GRAPHVIZ_OUT) -o $@ $<
endef

define gv-to-graph
	$(ll) file_target "$@" "Generating $(GRAPHVIZ_OUT) because" "$?"
	$(gv-graph)
	$(bin-stat)
	$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
endef

endif # /if GV_VERSION
