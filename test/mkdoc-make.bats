#!/usr/bin/env bats

load helper
init


@test "no arguments" {
  run $base
  common_test_conclusion ""
}


@test "clean" {
  run $base $BATS_TEST_DESCRIPTION
  common_test_conclusion "$BATS_TEST_DESCRIPTION"
}


@test "lists targets per group" {
  run $base lists
  common_test()
  {
    test ${status} -eq 0 && \
      fnmatch "*TRGT*:*Build Targets*" "${lines[*]}"
  }
  common_test_conclusion "lists"
}


@test "project info lists shell and make settings" {
  run $base info
  # FIXME: fnmatch "* Mkdoc: /[a-z]*" "${lines[*]}" &&
  common_test()
  {
    test ${status} -eq 0 &&
      fnmatch "*Root*:*/*" "${lines[*]}" &&
      fnmatch "*Project*:*mkdoc*" "${lines[*]}" &&
      fnmatch "*VPATH*:*" "${lines[*]}" &&
      fnmatch "*SHELL*:*/[a-z]*" "${lines[*]}" &&
      fnmatch "*CS*:*" "${lines[*]}"
  }
  common_test_conclusion "info"
}



