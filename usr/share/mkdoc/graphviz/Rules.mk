$(call log-module,"graphviz","Graphviz rules")
GRAPHVIZ_SUFFIX     := ,graph
#
#      ------------ -- 



### DOT png
%$(GRAPHVIZ_SUFFIX).png:           %.gv
	@$(gv-to-graph)
%$(GRAPHVIZ_SUFFIX).png:      GRAPHVIZ_OUT := png

$B%$(GRAPHVIZ_SUFFIX).png:         %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).png:    GRAPHVIZ_OUT := png


### png graphs from other engines
$B%,neato$(GRAPHVIZ_SUFFIX).png:   %.gv
	@$(gv-to-graph)
$B%,neato$(GRAPHVIZ_SUFFIX).png:     GRAPHVIZ_OUT := png
$B%,neato$(GRAPHVIZ_SUFFIX).png:  GRAPHVIZ_ENGINE := $(GRAPHVIZ_ENGINE:dot%=neato%)

$B%,twopi$(GRAPHVIZ_SUFFIX).png:   %.gv
	@$(gv-to-graph)
$B%,twopi$(GRAPHVIZ_SUFFIX).png:     GRAPHVIZ_OUT := png
$B%,twopi$(GRAPHVIZ_SUFFIX).png:  GRAPHVIZ_ENGINE := $(GRAPHVIZ_ENGINE:dot%=twopi%)

$B%,fdp$(GRAPHVIZ_SUFFIX).png:     %.gv
	@$(gv-to-graph)
$B%,fdp$(GRAPHVIZ_SUFFIX).png:     GRAPHVIZ_OUT := png
$B%,fdp$(GRAPHVIZ_SUFFIX).png:  GRAPHVIZ_ENGINE := $(GRAPHVIZ_ENGINE:dot%=fdp%)

$B%,circo$(GRAPHVIZ_SUFFIX).png:   %.gv
	@$(gv-to-graph)
$B%,circo$(GRAPHVIZ_SUFFIX).png:     GRAPHVIZ_OUT := png
$B%,circo$(GRAPHVIZ_SUFFIX).png:  GRAPHVIZ_ENGINE := $(GRAPHVIZ_ENGINE:dot%=circo%)

# XXX: non-graphviz svg -> png
#$B%.svg.png: 		$d/%.svg
#	@$(reset-target)
#	@rsvg-convert -o $@ $^
#	@file -s $@
#	@$(ee) "* $^ -> $@"



# DOT ps
%$(GRAPHVIZ_SUFFIX).ps:            %.gv
	@$(gv-to-graph)
%$(GRAPHVIZ_SUFFIX).ps:       GRAPHVIZ_OUT := ps

$B%$(GRAPHVIZ_SUFFIX).ps:          %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).ps:     GRAPHVIZ_OUT := ps

# DOT ps2 (PDF)
%$(GRAPHVIZ_SUFFIX),ps2.ps:            %.gv
	@$(gv-to-graph)
%$(GRAPHVIZ_SUFFIX),ps2.ps:       GRAPHVIZ_OUT := ps2

$B%$(GRAPHVIZ_SUFFIX),ps2.ps:          %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX),ps2.ps:     GRAPHVIZ_OUT := ps2

# DOT cmapx (HTML imagemap)
%$(GRAPHVIZ_SUFFIX).cmapx:         %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).cmapx:  GRAPHVIZ_OUT := cmapx

$B%$(GRAPHVIZ_SUFFIX).cmapx:       %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).cmapx:  GRAPHVIZ_OUT := cmapx

# DOT svg
%$(GRAPHVIZ_SUFFIX).svg:  %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).svg:  GRAPHVIZ_OUT := svg

$B%$(GRAPHVIZ_SUFFIX).svg:  %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).svg:  GRAPHVIZ_OUT := svg

# DOT svg:cairo
%$(GRAPHVIZ_SUFFIX).svg:  %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).svg:  GRAPHVIZ_OUT := svg:cairo

$B%$(GRAPHVIZ_SUFFIX).svg:  %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).svg:  GRAPHVIZ_OUT := svg:cairo



# third-party graph language
$B%,gxl.gv: %.gxl
	@$(ll) file_target "$@" because "$?"
	@gxl2gv -d -o$@ $< 
	@$(ll) file_ok "$@" Done

$B%,gv.gxl: %.gv
	@$(ll) file_target "$@" because "$?"
	@gxl2gv -g -o$@ $< 
	@$(ll) file_ok "$@" Done


#      ------------ -- 
#
