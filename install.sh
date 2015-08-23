#!/bin/bash

PREFIX=./usr/
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
  test -n "$MK_SHARE"
  test ! -e "$MK_SHARE"
  mkdir -p $(dirname $MK_SHARE)
  cp -vr usr/share/mkdoc/ $MK_SHARE
  cp -vr Mkdocs-*.mk Makefile.*boilerplate $MK_SHARE
}


[ ! -e "$MK_SHARE" ] || uninstall

install


