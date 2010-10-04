
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
	$(call rst-dep,$<,-) | while read f; do \
		echo $<: $$f >> $@; done;
endef

