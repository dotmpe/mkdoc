
.PHONY: check_bm_bin

check_bm_bin::
	@echo "DIR = $(DIR)"
	@echo "PREFIX = $(PREFIX) $(origin PREFIX)"
	@echo "location = $(location) $(origin location)"
	@echo "MK_SHARE = $(MK_SHARE) $(origin MK_SHARE)"
	@$(ll) attention $@ "Testing js2bm.pl"
	$(MK_SHARE)bookmarklet/js2bm.pl --help . 2>/dev/null >/dev/null
	@$(ll) ok $@ "js2bm.pl"
	

TEST += check_bm_bin

