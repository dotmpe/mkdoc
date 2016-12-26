# Id: mkdoc/0.0.2-test+20150804-0404 Rules.mkdoc.mk

include $(DIR)/Makefile.usage


# Track embedded task notes
TODO.list: $(SRC)
	-grep -srI 'TODO\|FIXME\|XXX' $^ | grep -v 'grep..srI..TODO' | grep -v 'TODO.list' > $@


# Updates files with embedded project/version lines

STRGT += sync-file-ids
sync-file-ids:
	./bin/cli-version.sh update


# Install mkdocs to MK_SHARE

PREFIX              ?= ./usr
MK_SHARE            ?= $(PREFIX)/share/mkdoc/

INSTALL             += $(MK_SHARE)

$(MK_SHARE):
	@./install.sh


include $(MK_SHARE)bookmarklet/Rules.test.mk


STRGT += uninstall reinstall
uninstall::
	P=$$(dirname $(MK_SHARE))/$$(basename $(MK_SHARE)); \
	[ "$P" != "/" ] && sudo rm -rfv $$P

reinstall:: uninstall install


