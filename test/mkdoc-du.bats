#!/usr/bin/env bats

# Id: mkdoc/0.0.2-test+20150804-0404 test/mkdoc-du.bats

version=0.0.2-test+20150804-0404 # mkdoc

load helper
init

@test "no arguments" {
  run ${base}
  common_test_conclusion ""
}

@test "clean" {
  run ${base} clean
  common_test_conclusion "clean"
}

@test "build rSt" {
  run ${base} main,du.pxml
  run ${base} main,du.xml
  common_test_conclusion "main,du.{p,}xml"
}

@test "build rSt to xHTML" {
  run ${base} ./.build/main.du.xhtml
  common_test_conclusion "./.build/main.du.xhtml"
}

@test "testing results" {
  run ${base} test-du-result
  diag "$(cat main,du.pxml)"
  common_test_conclusion "test-du-result"
}


