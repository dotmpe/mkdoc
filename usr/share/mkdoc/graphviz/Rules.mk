

$B%,gxl.gv: %.gxl
	@$(ll) file_target "$@" because "$?"
	@gxl2gv -d -o$@ $< 
	@$(ll) file_ok "$@" Done

$B%,gv.gxl: %.gv
	@$(ll) file_target "$@" because "$?"
	@gxl2gv -g -o$@ $< 
	@$(ll) file_ok "$@" Done


%,graph.ps:  %.gv
	@$(gv-to-ps)

$B%,graph.ps: 		%.gv
	@$(gv-to-ps)


%,graph.png:  %.gv
	@$(gv-to-png)

$B%,graph.png: 		%.gv
	@$(gv-to-png)


$B%,neato,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
$B%,neato,graph.png:  GRAPHVIZ_ENGINE:=$(GRAPHVIZ_ENGINE:dot%=neato%)

$B%,twopi,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
$B%,twopi,graph.png:  GRAPHVIZ_ENGINE:=$(GRAPHVIZ_ENGINE:dot%=twopi%)

$B%,fdp,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
$B%,fdp,graph.png:  GRAPHVIZ_ENGINE:=$(GRAPHVIZ_ENGINE:dot%=fdp%)

$B%,circo,graph.png:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-png)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
$B%,circo,graph.png:  GRAPHVIZ_ENGINE:=$(GRAPHVIZ_ENGINE:dot%=circo%)


#$B%.svg.png: 		$d/%.svg
#	@$(reset-target)
#	@rsvg-convert -o $@ $^
#	@file -s $@
#	@$(ee) "* $^ -> $@"


%,graph.cmapx:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-cmapx)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"

$B%,graph.cmapx:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-cmapx)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"


%,graph.svg:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-svg) -Tcmapx
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"

$B%,graph.svg:  %.gv
	@$(ll) file_target "$@" because "$?"
	@$(gv-svg)
	@$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"

