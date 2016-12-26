#!/usr/bin/env bats

# Id: mkdoc/0.0.2-test+20150804-0404 test/mkdoc-core.bats

version=0.0.2-test+20150804-0404 # mkdoc

base="make"

@test "no arguments" {
  run ${base}
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION (make)"
    }
}

@test "clean" {
  run ${base} clean clean-dep
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION (make clean clean-dep)"
    }
}

@test "build KEYWORDS tag file" {
  run ${base} clean
  run ${base} KEYWORDS
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION (make clean && make KEYWORDS)"
    }
}

@test "run ant-proc-tags on test file" {
  run ${base} ./test.file.src
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION (make ./test.file.src)"
    }
}

@test "check test file result" {
  run ${base} test-ante-proc-tags
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION (make test-ante-proc-tags)"
    }
}

