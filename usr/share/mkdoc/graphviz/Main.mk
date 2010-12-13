## Build diagrams
GRAPHVIZ_ENGINE := dot -Gsplines=true 
#values: dot,twopi,circo,fdp,neato



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

define gv-ps2
	$(reset-target)
	$(GRAPHVIZ_ENGINE) -Tps2 -o $@ $^
	$(ll) info "$@" "`file -bs $@`"
endef


define gv-to-png
	$(ll) file_target "$@" because "$?"
	$(gv-png)
	$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
endef

# PS for PDF
define gv-to-ps2 
	$(ll) file_target "$@" because "$?"
	$(gv-ps2)
	$(ll) file_ok "$@" "<--($(GRAPHVIZ_ENGINE))-" "$^"
endef


