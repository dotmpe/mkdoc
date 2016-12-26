#!/usr/bin/env bats


base="${MK_DIR}/usr/share/mkdoc/bookmarklet/js2bm.pl"
load helper

@test "js2bm" {
  run ${base} --help .
  common_test_conclusion "js2bm-run-check"
}


