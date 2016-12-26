#!/bin/bash

set -e

PREFIX=./usr
MK_SHARE=$PREFIX/share/mkdoc

function uninstall()
{
  test -n "$MK_SHARE"
  test -e "$MK_SHARE"

  # prevent removing linked dir
  P=$(dirname $MK_SHARE)/$(basename $MK_SHARE)
  [ "$P" != "/" ] && rm -rfv $P
}

function install()
{
  test -n "$MK_SHARE" || { echo "Expected dir setting MK_SHARE"; return 1; }
  test ! -e "$MK_SHARE" || { echo "Dir exits: $MK_SHARE"; return 1; }
  mkdir -p $(dirname $MK_SHARE) || { echo "Unable to make parent dir: $MK_SHARE"; return 1; }
  cp -vr usr/share/mkdoc $MK_SHARE || { echo "Copy to $MK_SHARE failed"; return 1; }
  cp -vr Mkdoc-*.mk Makefile.*boilerplate $MK_SHARE || { echo "Copy to $MK_SHARE failed"; return 2; }
}


test "$(basename $0)" = "install.sh" && {
  test -n "$1" || set -- install
  while test -n "$1"
  do
    $1 || exit $?
    shift
  done
} || printf ""

# Id: mkdoc/0.0.2-test+20150804-0404 install.sh
