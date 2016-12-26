#!/usr/bin/env bats

# Id: mkdoc/0.0.2-test+20150804-0404 test/mkdoc-minimal-core.bats


@test "$make_f" "no arguments" {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}

@test "$make_f stat" {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}

@test "$make_f clean clean-dep" {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}

@test "$make_f info" {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}

@test "$make_f list " {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}

@test "$make_f lists " {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}

@test "$make_f build" {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}

@test "$make_f test" {
  run $BATS_TEST_DESCRIPTION
  [ ${status} -eq 0 ]
}


