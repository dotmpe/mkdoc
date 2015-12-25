#!/usr/bin/env bats


@test "make" "no arguments" {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}


@test "make clean" {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}




