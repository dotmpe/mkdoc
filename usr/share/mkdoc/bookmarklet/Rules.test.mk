
.PHONY: check_bm_bin

check_bm_bin::
	@$(ll) attention $@ "Testing js2bm.pl"
	$(MK_SHARE)bookmarklet/js2bm.pl --help . 2>/dev/null >/dev/null
	@$(ll) ok $@ "js2bm.pl"
	

TEST += check_bm_bin

