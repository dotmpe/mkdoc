# Id: mkdoc/0.0.2-test+20150804-0404 Rules.mkdoc.shared.mk

$(eval $(call module-header,mkdoc.shared,$/Rules.mkdoc.shared.mk,Shared Mkdocs))


.PHONY: test-mkdoc-specs

test-mkdoc-specs:: DIR := $(shell dirname $(location))
test-mkdoc-specs:: PREFIX := $(DIR)/usr
test-mkdoc-specs:: MK_SHARE := $(DIR)/usr/share/mkdoc/
test-mkdoc-specs::
	@case "$(DEBUG)" in 1|y*|j*|on|[Tt][Rr][Uu][Ee] ) \
		echo "DIR = $(DIR)"; \
		echo "PREFIX = $(PREFIX) $(origin PREFIX)"; \
		echo "location = $(location) $(origin location)"; \
		echo "MK_SHARE = $(MK_SHARE) $(origin MK_SHARE)";; \
	esac
	@\
		case "$(ll)" in /* ) ll="$(ll)" ;; * ) ll="$(DIR)/$(ll)" ;; esac; \
		export ll="$$ll" PREFIX=$(PREFIX) MK_DIR=${DIR} MK_SHARE=$(MK_SHARE); \
		./tools/ci/test-specs.sh "$@"
	@$(ll) ok $@ "specs for Core, Du, Make and BM"


TEST += test-mkdoc-specs

