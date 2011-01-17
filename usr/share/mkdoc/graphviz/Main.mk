$(call log-module,"graphviz","Graphviz graph rendering")

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


