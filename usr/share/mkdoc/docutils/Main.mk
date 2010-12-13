MK               += $(MK_SHARE)/docutils/Main.mk


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


XHT_CSS          :=
XHT_JS           :=


ifeq ($(shell which rst2xml),)
rst-html          = rst2html.py      $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-latex         = rst2latex.py     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_LATEX)
rst-man           = rst2man.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_MAN)
#rst-newlatex      = rst2newlatex.py  $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_NLATEX)
rst-odt           = rst2odt.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_ODT)
rst-pseudoxml     = rst2pseudoxml.py $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_PXML)
rst-s5            = rst2s5.py        $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_S5)
rst-xetex         = rst2xetex.py     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XETEX)
rst-xml           = rst2xml.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XML)
else
rst-html          = rst2html         $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-latex         = rst2latex        $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_LATEX)
rst-man           = rst2man          $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_MAN)
#rst-newlatex      = rst2newlatex     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_NLATEX)
rst-odt           = rst2odt          $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_ODT)
rst-pseudoxml     = rst2pseudoxml    $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_PXML)
rst-s5            = rst2s5           $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_S5)
rst-xetex         = rst2xetex        $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XETEX)
rst-xml           = rst2xml          $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XML)
endif
# FIXME: fail if any of the above do not exist..
rst-dep           = $(rst-xml) --record-dependencies=$2 $1 /dev/null 2> /dev/null
path2rstlist      = $(MK_SHARE)/docutils/path2rstlist.py
rst-pre-proc-include = $(MK_SHARE)/docutils/rst-includes.py
rst-pdf-figure-to-png = $(MK_SHARE)/docutils/rst-pdf-figure-to-png.py


define mk-rst-include-deps
	# pre-proc
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ante-proc-tags),
		$(shell cp $< $<.src))
	# write deps
	# Rule-source is rSt file, rule-target the generated-makefile
	$(call rst-dep,$<.src,-) | while read f; do \
		DEPF=./$${f}; \
		DEPT=$${DEPF/%.rst/.xhtml}; \
		DEPT=$${DEPF/%.rst/.xhtml}; \
		RULEF=./$<;\
		DIR=$(call sed-escape,$(DIR)/);BUILD=$(call sed-escape,$(BUILD));\
		RULET=$${RULEF/%.rst/.xhtml};RULET=$${RULET/#$$DIR/$$BUILD};\
		echo "#  Rule: $@: $< "> $@; \
		echo "#     *: $* ">> $@; \
		echo "#   DIR: $$DIR ">> $@; \
		echo "#   DEP: $$f ">> $@; \
		echo "# BUILD: $$BUILD  ">> $@; \
		echo "$$DEPT: DIR := $$DIR ">> $@; \
		echo "$$DEPT: $$DEPF ">> $@; \
		echo "$@: $$RULEF $$DEPF $(call rules,$(DIR))">> $@; \
		echo "$$RULET: $$DEPF ">> $@; done
endef


define rst-to-src
	$(ll) file_target "$@" "Updating Document from rSt" "$<"
endef

# ready to use recipes
define rst-to-latex
	$(ll) file_target "$@" because "$?"
	$(reset-target)
	$(if $(call is-file,$(shell $(kwds-file))),
	 $(ante-proc-tags),
	 $(shell cp $< $<.src))
	#echo $(rst-latex) $(<F).src $$T
	T=$$(realpath $@);cd $(<D);$(rst-latex) $(<F).src $$T
	rm $<.src
	$(ll) file_ok "$@" Done
endef

define rst-to-pseudoxml
	$(ll) file_target "$@" because "$?"
	$(reset-target)
	T=$$(realpath $@);cd $(<D);$(rst-pseudoxml) $(<F) $$T
	$(ll) file_ok "$@" Done
endef


define rst-to-xhtml
	$(ll) file_target "$@" "Building XHTML from rSt" "$<"
	$(reset-target)
	# pre-proc
	$(if $(call is-file,$(shell $(kwds-file))),
		$(ante-proc-tags),
		$(shell cp $< $<.src))
	#./opt/rst-preproc.py --alt-headers < $<.tmp > $<.src
	# Add path list
	$(path2rstlist) /$< >> $<.src
	# Rewrite includes (includes must be non-indented!)
	$(rst-pre-proc-include) $<.src > $<.src2
	mv $<.src2 $<.src
	# Rewrite PDF image/figure to PNG
	$(rst-pdf-figure-to-png) $<.src > $<.src2
	mv $<.src2 $<.src
	# Make XHTML tree (in original directory)
	# --source-url="/$<.rst" XXX extension gets stripped
	#echo $(rst-html) $<.src $@.tmp1
	#echo 'READ ' $(DU_READ)
	#echo 'HTML ' $(DU_HTML)
	#echo 'GEN ' $(DU_GEN)
	$(rst-html) $<.src $@.tmp1
	cp $<.src $@.src
	rm $<.src
	# Additional styles 'n scripts
	JS="$(call sed-escape,$(XHT_JS))"; \
	   for js_ref in $${JS}; do \
	   	sed -e "s/<\/head>/<script type=\"text\/javascript\" src=\"$$js_ref\"><\/script><\/head>/" $@.tmp1 > $@.tmp2; \
	   	mv $@.tmp2 $@.tmp1; \
	   done;
	CSS="$(call sed-escape,$(XHT_CSS))"; \
	   for css_ref in $${CSS}; do \
	   	sed -e "s/<\/head>/<link rel=\"stylesheet\" type=\"text\/css\" href=\"$$css_ref\"\/><\/head>/" $@.tmp1 > $@.tmp2; \
	   	mv $@.tmp2 $@.tmp1; \
	   done;
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
	BASE_URI=`echo "$(BASE_HREF)" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`;\
	ROOT=`echo "$(ROOT)" | awk '{gsub("[~/:]", "\\\\\\\&");print}'`;\
	sed \
		-e "s/src=\"$$ROOT\(.\+\)\"/src=\"\1\"/g" \
		-e "s/href=\"$$ROOT\(.\+\)\"/href=\"\1\"/g" \
		-e "s/href=\"\(.\+\)\.rst\"/href=\"\1\"/g" \
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
	ls "$(<D)" | sed -e 's/\(\.xhtml\|\.rst\|\.png\|\.dot\|\.tab\|\.list\|\.csv\|\.txt\|\.html\|\.xml\|\.js\|\.jpg\)$$//g' - | sort -u |\
  	 while read f; \
	   do echo "      - \`$$f <./$$f>\`_" >> $<.tmp-index; done;
	mv $<.tmp-index $@
endef

