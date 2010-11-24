define gv-png
	$(reset-target)
	$(GRAPHVIZ_ENGINE) -Tpng -o $@ $^
	$(ll) info "$@" "`file -bs $@`"
endef

define gv-svg
	$(reset-target)
	$(GRAPHVIZ_ENGINE) -Tsvg:cairo -o $@ $^
	$(ll) info "$@" "`file -bs $@`"
endef


%,gxl.gv: %.gxl
	@$(ll) file_target "$@" because "$?"
	@gxl2gv -d -o$@ $< 
	@$(ll) file_ok "$@" Done

%,gv.gxl: %.gv
	@$(ll) file_target "$@" because "$?"
	@gxl2gv -g -o$@ $< 
	@$(ll) file_ok "$@" Done


%,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"

$(BUILD)%.gv.png: 		%.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"


$(BUILD)%,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"


$(BUILD)%,neato,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
$(BUILD)%,neato,graph.png:  GRAPHVIZ_ENGINE:=$(GRAPHVIZ_ENGINE:dot%=neato%)

$(BUILD)%,twopi,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
$(BUILD)%,twopi,graph.png:  GRAPHVIZ_ENGINE:=$(GRAPHVIZ_ENGINE:dot%=twopi%)

$(BUILD)%,fdp,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
$(BUILD)%,fdp,graph.png:  GRAPHVIZ_ENGINE:=$(GRAPHVIZ_ENGINE:dot%=fdp%)

$(BUILD)%,circo,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
$(BUILD)%,circo,graph.png:  GRAPHVIZ_ENGINE:=$(GRAPHVIZ_ENGINE:dot%=circo%)


#$(BUILD)%.svg.png: 		$d/%.svg
#	@$(reset-target)
#	@rsvg-convert -o $@ $^
#	@file -s $@
#	@$(ee) "* $^ -> $@"


%,graph.svg:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-svg)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"

$(BUILD)%,graph.svg:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-svg)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"

