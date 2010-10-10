MK               += $(DIR)/docutils/Main.mk


DU_GEN           := --language=en
DU_HTML          := --field-name-limit=22 --link-stylesheet
DU_XML           := 

ifeq ($(shell which rst2xml),)
rst-xhtml   = rst2html.py $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-xml     = rst2xml.py $(DU_GEN) $(DU_READ) $(DU_XML)
else
rst-xhtml   = rst2html $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-xml     = rst2xml $(DU_GEN) $(DU_READ) $(DU_XML)
endif
rst-dep     = $(rst-xml) --record-dependencies=$2 $1 /dev/null 2> /dev/null
tidy-xhtml  = tidy -q -wrap 0 -asxhtml -utf8 -i


define mk-rst-include-deps
	# pre-proc
	echo $(shell $(kwds-file))
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ante-proc-tags),
		$(shell cp $< $<.src))
	$(call rst-dep,$<.src,-) | while read f; do \
		DIR=$(<D);\
		DIR=$${DIR##./}/;\
		F=$${f##$$DIR}; \
		T=$${f/%.rst/.xhtml}; \
		T=$${f};\
		echo $$T: DIR := $$DIR >> $@; \
		echo $$T: $$F >> $@; done;
	#rm $<.src;
endef

define rst-to-xhtml
	$(ll) file_target "$@" "Building XHTML from rSt" "$<"
	$(reset-target)
	# pre-proc
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ante-proc-tags),
		$(shell cp $< $<.src))
	#./opt/rst-preproc.py --alt-headers < $< > $<.tmp
	# Add path list
	#path2rstlist.py /$< >> $<.tmp
	# Add leaf navigation list
	#tools/path2rstnav.py $< >> $<.tmp
	# Make XHTML tree
	$(rst-xhtml) $<.src $<.tmp2
	#rm $<.src;
	# Additional styles 'n scripts
	JS=`echo "$(XHT_JS)"| tr ' ' ' '`; \
	   for js_ref in $${JS}; do \
	   	sed -e "s/<\/head>/<script type=\"text\/javascript\" src=\"$$js_ref\"><\/script><\/head>/" $<.tmp2 > $<.tmp3; \
	   	mv $<.tmp3 $<.tmp2; \
	   done;
	CSS=`echo "$(XHT_CSS)"|tr ' ' ' '`; \
	   for css_ref in $${CSS}; do \
	   	sed -e "s/<\/head>/<link rel=\"stylesheet\" type=\"text\/css\" href=\"$$css_ref\"\/><\/head>/" $<.tmp2 > $<.tmp3; \
	   	mv $<.tmp3 $<.tmp2; \
	   done;
	# Process references, must be relative or absolute to base URI
	#$(build-xhtml-refs) $<.tmp2 > $@
	#rm $<.tmp2
	mv $<.tmp2 $@
	# Tidy up html output
#	@-$(tidy-xhtml) $@.tmp > $@; \
#	 if test $$? -gt 0; then $(ee) ""; fi; # put xtra line if err-msgs
endef

define build-xhtml-refs
	# allow docs to make absolute references to withing the project
	# XXX: it appears that setting HTML base href is not enough for the browser
	# to resolve link/script references?
	BASE_URI=`echo "$(BASE_HREF)" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`;\
	sed \
		-e "s/<table/<table summary=\"Docutils rSt table\"/g" \
			$<.tmp2 > $@ 
@#		-e "s/<\/head>/<base href=\"$$BASE_URI\" \/><\/head>/"\
@#		-e "s/href=\"\//href=\"$$BASE_URI/g"\
@#		-e "s/src=\"\//src=\"$$BASE_URI/g" 
endef


define build-dir-index-rst
	# FIXME: would be nice if this could exclude current target.
	# XXX: this is dep'ed on everything in the dir and gets regenerated every time..
	$(reset-target)
	$(ee) ".. container:: directory\n" > $<.tmp-index
	$(ee) "   .. class:: flat-index\n" >> $<.tmp-index
	ls "$<" | sed -e 's/\(\.xhtml\|\.rst\|\.png\|\.dot\|\.tab\|\.list\|\.csv\|\.txt\|\.html\|\.xml\|\.js\|\.jpg\)$$//g' - | sort -u |\
  	 while read f; \
	   do echo "      - \`$$f <./$$f>\`_" >> $<.tmp-index; done;
	mv $<.tmp-index $@
endef

