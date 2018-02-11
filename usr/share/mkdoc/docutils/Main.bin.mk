#$(eval $(call module-header,docutils,$(MK_SHARE)docutils/Main.bin.mk,GNU/docutils binaries))
#
#      ------------ -- 

ifneq ($(shell which rst2xml),)
rst-html          = rst2html         $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-latex         = rst2latex        $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_LATEX)
rst-man           = rst2man          $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_MAN)
#rst-newlatex      = rst2newlatex     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_NLATEX)
rst-odt           = rst2odt          $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_ODT)
rst-pseudoxml     = rst2pseudoxml    $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_PXML)
rst-s5            = rst2s5           $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_S5)
rst-xetex         = rst2xetex        $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XETEX)
rst-xml           = rst2xml          $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XML)
else
ifneq ($(shell which rst2xml-2.6.py),)
# Py26 under Mac OS X (Darwin 10.6 with macports)
rst-html          = rst2html-2.6.py      $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-latex         = rst2latex-2.6.py     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_LATEX)
rst-man           = rst2man-2.6.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_MAN)
#rst-newlatex      = rst2newlatex-2.6.py  $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_NLATEX)
rst-odt           = rst2odt-2.6.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_ODT)
rst-pseudoxml     = rst2pseudoxml-2.6.py $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_PXML)
rst-s5            = rst2s5-2.6.py        $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_S5)
rst-xetex         = rst2xetex-2.6.py     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XETEX)
rst-xml           = rst2xml-2.6.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XML)
else
rst-html          = rst2html.py      $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_HTML)
rst-latex         = rst2latex.py     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_LATEX)
rst-man           = rst2man.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_MAN)
#rst-newlatex      = rst2newlatex.py  $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_NLATEX)
rst-odt           = rst2odt.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_ODT)
rst-pseudoxml     = rst2pseudoxml.py $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_PXML)
rst-s5            = rst2s5.py        $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_S5)
rst-xetex         = rst2xetex.py     $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XETEX)
rst-xml           = rst2xml.py       $(DU_RST) $(DU_GEN) $(DU_READ) $(DU_XML)
endif
endif

# fail if any of the above do not exist
ifeq ($(shell which $(rst-html)),)
$(call chat,warn,docutils,Missing Docutils)
endif

DU_VERSION=$(shell $(rst-xml) --version)

list-references   = $(rst-xml) $1 | xsltproc --novalid $(MK_SHARE)docutils/refuri-dep.xslt -
list-titles       =
rst-doc-title     = $(rst-xml) $1 | xsltproc --novalid $(MK_SHARE)docutils/doc-title.xslt -
rst-xml-doc-title = xsltproc --novalid $(MK_SHARE)docutils/doc-title.xslt $1
#tab-titles        = $(foreach $1,RST,$(shell find XML from env?))
rst-dep           = $(rst-xml) --record-dependencies=$2 $1 /dev/null 2> /dev/null
path2rstlist      = $(MK_SHARE)/docutils/path2rstlist.py
rst-pre-proc-include = $(MK_SHARE)/docutils/rst-includes.py
rst-pdf-figure-to-png = $(MK_SHARE)/docutils/rst-pdf-figure-to-png.py
