MK               += $(MK_SHARE)/docutils/Main.bin.mk
#
#      ------------ -- 

# Set BIN for all tools, or set to echo & exit if not exists to avoid silend
# failures later during build. For best handling build may want to call get-bin
# by itself. 

$(foreach DU_BIN,rst2html rst2latex rst2man rst2odt rst2pseudoxml rst2s5 rst2xetex rst2xml,\
$(if $(shell which $(DU_BIN)),$(eval \
BIN                 += $(DU_BIN)=$(shell which $(DU_BIN))), \
$(if $(shell which $(DU_BIN).py),$(eval \
BIN                 += $(DU_BIN)=$(shell which $(DU_BIN).py)), \
$(if $(shell which $(DU_BIN)-$(PY_MM_VERSION).py),$(eval \
BIN                 += $(DU_BIN)=$(shell which $(DU_BIN)-$(PY_MM_VERSION).py)),\
$(eval $(info $(shell $(ll) warning "docutils" "no $(DU_BIN) available")))))))

get-du-bin = $(call require-bin,$1) || echo '$$(ll) "error" "Docutils: Missing $1" && exit 1;'

# Prepare cmdline snippets including flags
rst-html          = $(shell $(call get-du-bin,rst2html))      $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-latex         = $(shell $(call get-du-bin,rst2latex))     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_LATEX)
rst-man           = $(shell $(call get-du-bin,rst2man))       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_MAN)
rst-newlatex      = $(shell $(call get-du-bin,rst2newlatex))  $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_NLATEX)
rst-odt           = $(shell $(call get-du-bin,rst2odt))       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_ODT)
rst-pseudoxml     = $(shell $(call get-du-bin,rst2pseudoxml)) $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_PXML)
rst-s5            = $(shell $(call get-du-bin,rst2s5))        $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_S5)
rst-xetex         = $(shell $(call get-du-bin,rst2xetex))     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XETEX)
rst-xml           = $(shell $(call get-du-bin,rst2xml))       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XML)


$(call chat,debug,rst-html=$(rst-html))

ifeq ($(shell which $(rst-html)),)
$(call chat,err,docutils,Missing Docutils)
endif

# Utility commandline snippets
#
list-references   = $(rst-xml) $1 | xsltproc --novalid $(MK_SHARE)docutils/refuri-dep.xslt -
list-titles       =
rst-doc-title     = $(rst-xml) $1 | xsltproc --novalid $(MK_SHARE)docutils/doc-title.xslt -
rst-xml-doc-title = xsltproc --novalid $(MK_SHARE)docutils/doc-title.xslt $1
#tab-titles        = $(foreach $1,RST,$(shell find XML from env?))
rst-dep           = $(rst-xml) --record-dependencies=$2 $1 /dev/null 2> /dev/null
path2rstlist      = $(MK_SHARE)/docutils/path2rstlist.py
rst-pre-proc-include = $(MK_SHARE)/docutils/rst-includes.py
rst-pdf-figure-to-png = $(MK_SHARE)/docutils/rst-pdf-figure-to-png.py


test-docutils:
	@echo "Test" > test.rst
	@$(rst-xetex) test.rst
	@$(rst-html) test.rst
	@$(rst-xml) test.rst
	@$(rst-latex) test.rst
	@$(rst-newlatex) test.rst
	@rm test.rst

#      ------------ -- 
#
