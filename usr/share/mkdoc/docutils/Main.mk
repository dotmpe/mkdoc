$(eval $(call module-header,docutils,$(MK_SHARE)docutils/Main.mk,"Docutils Python document publisher"))
#
#      ------------ -- 



# generic Du flags
DU_GEN           := --language=en --traceback --no-generator \
	--no-footnote-backlinks -i utf-8 -o utf-8 --date \
# Du (Stand alone) reader flags
DU_READ          := --no-section-subtitles
# Du rSt parser flags
DU_RST           := \
	--file-insertion-enabled \
	--pep-references \
	--rfc-references --rfc-base-url=http://tools.ietf.org/html/rfc
# writer flags
DU_HTML          := --field-name-limit=22 --link-stylesheet \
	--no-compact-lists \
	--footnote-references=superscript --cloak-email-addresses 
DU_XML           := 
DU_LATEX         := --use-latex-docinfo --documentclass=article --lang=nl \
	--documentoptions="14pt,a4paper" 
#old DU_NLATEX        := 
DU_ODT           := --create-sections --create-links --generate-oowriter-toc \
	--add-syntax-highlighting 
# XXX: not working in Du/0.7 --cloak-email-addresses 
# --stylesheet=/usr/share/pyshared/docutils/writers/odf_odt/styles.odt
# --odf-config-file=
# --custom-odt-header=CUSTOM_HEADER --custom-odt-footer=CUSTOM_FOOTER
DU_MAN           :=
DU_PXML          :=
DU_S5            :=
DU_XETEX         :=

# hack to append head elements without customized docutil publisher
XHT_CSS          :=
XHT_JS           :=
XHT_HEAD         :=


include             $(MK_SHARE)/docutils/Main.bin.mk


define mk-rst-include-deps
	# pre-proc
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ante-proc-tags),
		$(shell cp $< $<.src))
	# write deps
	# Rule-source is rSt file, rule-target the generated-makefile
	if test -n "$(VERBOSE)"; then \
		echo $(call rst-dep,$<.src,-); fi;
	DIR=$(call f-sed-escape,$(DIR)/); \
	BUILD=$(call f-sed-escape,$(BUILD));\
	RULEF=./$<;\
	RULET=$${RULEF/%.rst/.xhtml};RULET=$${RULET/#$$DIR/$$BUILD};\
	echo "#        $* ">> $@; \
	echo "#   DIR: $$DIR ">> $@; \
	echo "# BUILD: $$BUILD  ">> $@; \
	echo >> $@;\
	$(call rst-dep,$<.src,-) | while read f; do \
		DEPF=./$${f}; \
		DEPT=$${DEPF/%.rst/.xhtml}; \
		echo "$$RULET: $$DEPF ">> $@; \
	done; \
	echo >> $@;\
	echo "$$RULET: $@">> $@;\
	echo "$@: ./$< $(call rules,$(DIR))">> $@; 
endef
#		echo "$$DEPT: DIR := $$DIR ">> $@; \
#		echo "$$DEPT: $$DEPF ">> $@; \


define rst-to-src
	$(ll) file_target "$@" "Updating Document from rSt" "$<"
endef

# ready to use recipes
define rst-to-latex
	### Pre-processing
	cp $< $<.src
	chmod +rw $<.src
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ante-proc-tags))
	if test -n "$(PRE_PROC_INCLUDES)"; then\
		$(ll) info "source includes" "$$($(rst-pre-proc-include) $<.src $<.src2)"; \
		mv $<.src2 $<.src;\
	fi;
	T=$$(realpath $@);cd $(<D);$(rst-latex) $(<F).src $$T
	rm $<.src
endef

define rst-to-pseudoxml
	T=$$(realpath $@);cd $(<D);$(rst-pseudoxml) $(<F) $$T
endef

define rst-to-xhtml
	### Pre-processing
	cp $< $<.src
	chmod +rw $<.src
	[ -e "$$(dirname $@)" ] || { mkdir -p $$(dirname $@); }
	# Rewrite KEYWORD tags (twice, one before, one after includes. need to have
	# better included doc processing...)
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ll) info "source tags" "Expanding keywords tags from " $$($(kwds-file));
		$(ante-proc-tags))
	# oldish ./opt/rst-preproc.py --alt-headers < $<.tmp > $<.src
	# Add path list
	$(path2rstlist) /$< >> $<.src
	# Rewrite includes (includes must be non-indented!)
	if test -n "$(PRE_PROC_INCLUDES)"; then\
		$(ll) info "source includes" "$$($(rst-pre-proc-include) $<.src $<.src2)"; \
		mv $<.src2 $<.src;\
	fi;
	# XXX: KEYWORDS only processed for main file if PRE_PROC_INCLUDES
	#	$(if $(call is-file,$(shell $(kwds-file))),\
	#		$(ll) info "source tags" "Expanding keywords tags (after includes) from " $$($(kwds-file));\
	#		$(ante-proc-tags))\
	# Rewrite PDF image/figure to PNG
	$(ll) info "web types" "$$($(rst-pdf-figure-to-png) $<.src $<.src2)"
	mv $<.src2 $<.src
	# Make XHTML tree (in original directory)
	# --source-url="/$<.rst" XXX extension gets stripped
	#echo $(rst-html) $<.src $@.tmp1
	#echo 'READ ' $(DU_READ)
	#echo 'HTML ' $(DU_HTML)
	#echo 'GEN ' $(DU_GEN)
	if test -n "$(VERBOSE)"; \
	then $(rst-html) --traceback $<.src $@.tmp1;\
	else $(rst-html) $<.src $@.tmp1; fi
	cp $<.src $@.src
	rm $<.src
	\
	# Additional styles 'n scripts
	mkdocs_file=$$(dirname $<)/$$(basename $< .rst).mkdocs; \
	[ -e "$$mkdocs_file" ] && source "$$mkdocs_file"; \
	XHT_CSS="$$(echo $$XHT_CSS $(XHT_CSS))"; \
	if test -n "$(VERBOSE)"; \
		then $(ll) info "$@" "Adding styles" "$$XHT_CSS"; fi; \
	CSS=$$(echo "$$XHT_CSS" | $(sed-escape));\
	   for css_ref in $${CSS}; do \
	   	sed -e "s/<\/head>/<link rel=\"stylesheet\" type=\"text\/css\" href=\"$$css_ref\"\/><\/head>/" $@.tmp1 > $@.tmp2; \
	   	mv $@.tmp2 $@.tmp1; \
	   done; \
	\
	XHT_JS="$$(echo $$XHT_JS $(XHT_JS))"; \
	if test -n "$(VERBOSE)"; \
		then $(ll) info "$@" "Adding scripts" "$$XHT_JS"; fi; \
	JS=$$(echo "$$XHT_JS" | $(sed-escape));\
		for js_ref in $${JS}; do \
		sed -e "s/<\/head>/<script type=\"text\/javascript\" src=\"$$js_ref\"><\/script><\/head>/" $@.tmp1 > $@.tmp2; \
		mv $@.tmp2 $@.tmp1; \
	done;\
	\
	if test -n "$(VERBOSE)"; \
		then $(ll) info "$@" "Adding HTML head elements" "$(XHT_HEAD)"; fi; \
	for head_ref in $(XHT_HEAD); do \
		ref=$$(echo $$head_ref | sed 's/([^a-zA-Z0-9])/\\1/g');\
		sed -e "s#</head>#$$ref</head>#" $@.tmp1 > $@.tmp2; \
		mv $@.tmp2 $@.tmp1; \
	done; \
	\
	# Process references
	$(build-xhtml-refs)
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
	#echo $@ $(BASE_HREF) `echo "$(BASE_HREF)" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`;\
	#BASE_URI=`echo "$(BASE_HREF)" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`;\
	#
	ROOT=`echo "$(ROOT)" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`;\
	[ -z "$$ROOT" ] && echo error Empty var ROOT && exit 4;\
	sed \
		-e "s/src=\"$$ROOT\(.\+\)\"/src=\"\1\"/g" \
		-e "s/href=\"$$ROOT\(.\+\)\"/href=\"\1\"/g" \
		-e "s/href=\"\(.\+\)\.rst\"/href=\"\1\"/g" \
		-e "s/<table/<table summary=\"Docutils table\"/g" \
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
	ls "$(<D)" | sed -e 's/\(\.xhtml\|\.rst\|\.png\|\.dot\|\.tab\|\.list\|\.csv\|\.txt\|\.html\|\.xml\|\.js\|\.jpg\)$$//g' | sort -u |\
  	 while read f; \
	   do echo "      - \`$$f <./$$f>\`_" >> $<.tmp-index; done;
	mv $<.tmp-index $@
endef

