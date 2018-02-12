#!/usr/bin/env bats

load helper
base=

setup()
{
  test -n "$ENV_NAME" || export ENV_NAME=dev
  init
  diag "base: $base"
}


@test "no arguments" {
  run $base
  common_test_conclusion ""
}


@test "clean" {
  run $base $BATS_TEST_DESCRIPTION
  common_test_conclusion "$BATS_TEST_DESCRIPTION"
}


@test "help-vars lists targets per group" {
  run $base help-vars
  common_test()
  {
    test ${status} -eq 0 && \
      fnmatch "*SRC*:*" "${lines[*]}" &&
      fnmatch "*TRGT*:*Build Targets*" "${lines[*]}" &&
      fnmatch "*TEST*:*Test Targets*" "${lines[*]}"
  }
  common_test_conclusion "help-targets"
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


@test "mkdoc picks up rules" {

  pwd=$(pwd -P)
  test -n "$TMPDIR" || export TMPDIR=/tmp
  test -n "$MK_SHARE" || {
    export MK_SHARE=$pwd/usr/share/mkdoc
  }
  
  tmpd=$TMPDIR/mkdoc-test
  mkdir -vp $tmpd
  { cat <<EOF
HOST = myHost
PROJECT := myProject
include $MK_SHARE/Core/Main.mk
\$(info \$(call rules,./))
EOF
  } > $tmpd/Makefile
  touch $tmpd/.Rules.mk
  touch $tmpd/.Rules.myProject.mk
  touch $tmpd/.Rules.myHost.mk
  touch $tmpd/Rules.mk
  touch $tmpd/Rules.mkdoc.mk
  touch $tmpd/Rules.myProject.mk
  touch $tmpd/Rules.myHost.mk
  touch $tmpd/Rules.third-party.mk
  touch $tmpd/.Rules.third-party.shared.mk
  touch $tmpd/Rules.third-party.shared.mk

  cd $tmpd
  run make
  cd $pwd
  rm -rf $tpmd
  common_test() {
    test ${status} -eq 0 &&
      fnmatch "* ./.Rules.mk *" "${lines[*]}" &&
      fnmatch "* ././Rules.mk *" "${lines[*]}" &&
      fnmatch "* ./.Rules.myProject.mk *" "${lines[*]}" &&
      fnmatch "* ././Rules.myProject.mk *" "${lines[*]}" &&
      fnmatch "* ./.Rules.third-party.shared.mk *" "${lines[*]}" &&
      fnmatch "* ././Rules.third-party.shared.mk *" "${lines[*]}"
  }
# FIXME: match on HOST not working:
#      fnmatch "* ././Rules.myHost.mk *" "${lines[*]}"
  common_fail_extra() {
    diag "Temp dir = $tmpd"
    diag "Host = $myHost"
  }
  common_test_conclusion "mkdoc rules"
}

