#!/usr/bin/env bats

# Id: mkdoc/0.0.2-test+20150804-0404 test/mkdoc-du.bats

version=0.0.2-test+20150804-0404 # mkdoc


@test "no arguments" {
  run make
  [ ${status} -eq 0 ]
}

@test "clean" {
  run make clean
  [ ${status} -eq 0 ]
}

@test "build rSt" {
  run make main,du.xml
  [ ${status} -eq 0 ]
}

@test "build rSt to xHTML" {
  run make ./.build/main.du.xhtml
  [ ${status} -eq 0 ]
}

@test "testing results" {
  run make test-du-result
  [ ${status} -eq 0 ]
}


