#!/usr/bin/env bats

# Id: mkdoc/0.0.2-test+20150804-0404 test/mkdoc-du.bats

version=0.0.2-test+20150804-0404 # mkdoc

base=make

@test "no arguments" {
  run ${base}
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION ($base)"
    }
}

@test "clean" {
  run ${base} $BATS_TEST_DESCRIPTION
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION ($base)"
    }
}

@test "build rSt" {
  run ${base} main,du.xml
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION ($base main,du.xml)"
    }
}

@test "build rSt to xHTML" {
  run ${base} ./.build/main.du.xhtml
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION ($base ./.build/main.du.xhtml)"
    }
}

@test "testing results" {
  run ${base} test-du-result
  test ${status} -eq 0 || {
      diag "Lines (${#lines[@]}): ${lines[*]}"
      fail "$BATS_TEST_DESCRIPTION (${base} test-du-result)"
    }
}


