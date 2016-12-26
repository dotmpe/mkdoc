#!/usr/bin/env bats


base="${MK_DIR}/usr/share/mkdoc/bookmarklet/js2bm.pl"


@test "js2bm" {
  run ${base} --help .
  test ${status} -eq 0 || {
      diag "lines (${#lines[@]}): ${lines[*]}"
      fail "$bats_test_description (--help .)"
    }
}


