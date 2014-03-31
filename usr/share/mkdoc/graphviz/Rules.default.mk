$(eval $(call module-header,graphviz,$(MK_SHARE)graphviz/Rules.default.mk,"Graphviz rules"))
#
#      ------------ -- 


GRAPHVIZ_SUFFIX     := -graph
#
#      ------------ -- 


ifneq ($(GV_VERSION),)

### DOT png
%$(GRAPHVIZ_SUFFIX).png:           %.gv
	@$(gv-to-graph)
%$(GRAPHVIZ_SUFFIX).png:            GRAPHVIZ_OUT := png

%_dot$(GRAPHVIZ_SUFFIX).png:       %.gv
	@$(gv-to-graph)
%_dot$(GRAPHVIZ_SUFFIX).png:        GRAPHVIZ_OUT := png

$B%$(GRAPHVIZ_SUFFIX).png:         %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX).png:          GRAPHVIZ_OUT := png

$B%_dot$(GRAPHVIZ_SUFFIX).png:     %.gv
	@$(gv-to-graph)
$B%_dot$(GRAPHVIZ_SUFFIX).png:      GRAPHVIZ_OUT := png


### png graphs from other engines
$B%_neato$(GRAPHVIZ_SUFFIX).png:   %.gv
	@$(gv-to-graph)
$B%_neato$(GRAPHVIZ_SUFFIX).png:    GRAPHVIZ_OUT := png
$B%_neato$(GRAPHVIZ_SUFFIX).png: GRAPHVIZ_ENGINE := $(GRAPHVIZ_ENGINE:dot%=neato%)

$B%_twopi$(GRAPHVIZ_SUFFIX).png:   %.gv
	@$(gv-to-graph)
$B%_twopi$(GRAPHVIZ_SUFFIX).png:    GRAPHVIZ_OUT := png
$B%_twopi$(GRAPHVIZ_SUFFIX).png: GRAPHVIZ_ENGINE := $(GRAPHVIZ_ENGINE:dot%=twopi%)

$B%_fdp$(GRAPHVIZ_SUFFIX).png:     %.gv
	@$(gv-to-graph)
$B%_fdp$(GRAPHVIZ_SUFFIX).png:      GRAPHVIZ_OUT := png
$B%_fdp$(GRAPHVIZ_SUFFIX).png:   GRAPHVIZ_ENGINE := $(GRAPHVIZ_ENGINE:dot%=fdp%)

$B%_circo$(GRAPHVIZ_SUFFIX).png:   %.gv
	@$(gv-to-graph)
$B%_circo$(GRAPHVIZ_SUFFIX).png:    GRAPHVIZ_OUT := png
$B%_circo$(GRAPHVIZ_SUFFIX).png: GRAPHVIZ_ENGINE := $(GRAPHVIZ_ENGINE:dot%=circo%)

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
%$(GRAPHVIZ_SUFFIX)_ps2.ps:            %.gv
	@$(gv-to-graph)
%$(GRAPHVIZ_SUFFIX)_ps2.ps:       GRAPHVIZ_OUT := ps2

$B%$(GRAPHVIZ_SUFFIX)_ps2.ps:          %.gv
	@$(gv-to-graph)
$B%$(GRAPHVIZ_SUFFIX)_ps2.ps:     GRAPHVIZ_OUT := ps2

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
$B%_gxl.gv: %.gxl
	@$(ll) file_target "$@" because "$?"
	@gxl2gv -d -o$@ $< 
	@$(ll) file_ok "$@" Done

$B%_gv.gxl: %.gv
	@$(ll) file_target "$@" because "$?"
	@gxl2gv -g -o$@ $< 
	@$(ll) file_ok "$@" Done

endif

#      ------------ -- 
#
