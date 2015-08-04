#!/usr/bin/env bats

# Id: mkdoc/0.0.2-test+20150804-0404 test/mkdoc-core.bats

version=0.0.2-test+20150804-0404 # mkdoc


@test "no arguments" {
  run make
  [ ${status} -eq 0 ]
}

@test "clean" {
  run make clean clean-dep
  [ ${status} -eq 0 ]
}

@test "build KEYWORDS tag file" {
  run make clean
  run make KEYWORDS
  [ ${status} -eq 0 ]
}

@test "run ant-proc-tags on test file" {
  run make ./test.file.src
  [ ${status} -eq 0 ]
}

@test "check test file result" {
  run make test-ante-proc-tags
  [ ${status} -eq 0 ]
}

