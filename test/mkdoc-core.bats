#!/usr/bin/env bats

# Id: mkdoc/0.0.2-test+20150804-0404 test/mkdoc-core.bats

version=0.0.2-test+20150804-0404 # mkdoc

load helper
init


@test "no arguments" {
  run ${base}
  common_test_conclusion ""
}

@test "clean" {
  run ${base} clean clean-dep
  common_test_conclusion "clean clean-dep"
}

@test "build KEYWORDS tag file" {
  run ${base} clean
  run ${base} KEYWORDS
  common_test_conclusion "KEYWORDS"
}

@test "run ant-proc-tags on test file" {
  run ${base} ./test.file.src
  common_test_conclusion "./test.file.src"
}

@test "check test file result" {
  run ${base} test-ante-proc-tags
  common_test_conclusion "test-ante-proc-tags"
}

