MK               += $(MK_SHARE)/docutils/Main.mk


DU_READ          := 
DU_GEN           := --language=en --traceback --no-generator \
	--no-footnote-backlinks -i utf-8 -o utf-8 --date
DU_HTML          := --field-name-limit=22 --link-stylesheet --no-compact-lists \
	--footnote-references=superscript --cloak-email-addresses 
DU_XML           := 
DU_LATEX         := --use-latex-docinfo --documentclass=article --lang=nl \
	--documentoptions="14pt,a4paper" 
DU_ODT           := --create-sections --create-links --generate-oowriter-toc \
	--add-syntax-highlighting 
#--cloak-email-addresses 
# --stylesheet=/usr/share/pyshared/docutils/writers/odf_odt/styles.odt
# --odf-config-file=
# --custom-odt-header=CUSTOM_HEADER --custom-odt-footer=CUSTOM_FOOTER


XHT_CSS          :=
XHT_JS           :=


ifeq ($(shell which rst2xml),)
rst-xhtml         = rst2html.py $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-xml           = rst2xml.py $(DU_GEN) $(DU_READ) $(DU_XML)
else
rst-xhtml         = rst2html $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-xml           = rst2xml $(DU_GEN) $(DU_READ) $(DU_XML)
endif
rst-dep           = $(rst-xml) --record-dependencies=$2 $1 /dev/null 2> /dev/null
path2rstlist      = $(MK_SHARE)/docutils/path2rstlist.py


define mk-rst-include-deps
	# pre-proc
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
endef


define rst-to-xhtml
	$(ll) file_target "$@" "Building XHTML from rSt" "$<"
	$(reset-target)
	# pre-proc
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ante-proc-tags),
		$(shell cp $< $<.src))
	mv $<.src $@.src
	#./opt/rst-preproc.py --alt-headers < $<.tmp > $<.src
	#$(ee) "\n.. header::\n   \n   - null\n\n..\n" >> $@.src
	# Add path list
	$(path2rstlist) /$< >> $@.src
	# Make XHTML tree (in original directory)
	cp $@.src $<.src
	$(rst-xhtml) $<.src $@.tmp1
	rm $<.src
	# Additional styles 'n scripts
	JS=`echo "$(XHT_JS)"| tr ' ' ' '`; \
	   for js_ref in $${JS}; do \
	   	sed -e "s/<\/head>/<script type=\"text\/javascript\" src=\"$$js_ref\"><\/script><\/head>/" $@.tmp1 > $@.tmp2; \
	   	mv $@.tmp2 $@.tmp1; \
	   done;
	CSS=`echo "$(XHT_CSS)"|tr ' ' ' '`; \
	   for css_ref in $${CSS}; do \
	   	sed -e "s/<\/head>/<link rel=\"stylesheet\" type=\"text\/css\" href=\"$$css_ref\"\/><\/head>/" $@.tmp1 > $@.tmp2; \
	   	mv $@.tmp2 $@.tmp1; \
	   done;
	# Process references
	$(build-xhtml-refs)
	# Tidy up html output
	#$(tidy-xhtml) $@.tmp1 > $@; \
	#mv $@ $@.tmp1
	rm $@.tmp1
	# Check output		
	$(tidy-check) $@; \
	 if test $$? -gt 0; then $(ee) ""; fi; # put xtra line if err-msgs
endef
#@sed -e 's/<p>\[\([0-9]*\)\.\]<\/p>/<a id="page-\1" class="pagebreak"><\/a>/g' $@.tmp1 > $@.tmp2
#@sed -e 's/\[\([0-9]*\)\.\]/<a id="page-\1" class="pagebreak"><\/a>/g' $@.tmp2 > $@

define build-xhtml-refs
	# , must be relative or absolute to base URI
	# replace .rst ext
	# allow docs to make absolute references to withing the project
	# XXX: it appears that setting HTML base href is not enough for the browser
	# to resolve link/script references?
	BASE_URI=`echo "$(BASE_HREF)" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`;\
	sed \
		-e 's/href="\(.\+\)\.rst"/href="\1"/g' \
		-e "s/<table/<table summary=\"Docutils rSt table\"/g" \
			$@.tmp1 > $@ 
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

