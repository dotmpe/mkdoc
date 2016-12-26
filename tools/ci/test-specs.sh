#!/bin/sh

set -e
test -n "$ll"
test -n "$MK_DIR"
test -n "$MK_SHARE"
test -n "$PREFIX"


$ll attention $1 "Testing Core"
cd $MK_DIR/test/example/core/keywords
bats ../../../mkdoc-core.bats


$ll attention $1 "Testing Du"
cd $MK_DIR/test/example/du/
bats ../../mkdoc-du.bats


$ll attention $1 "Testing Make"
cd $MK_DIR/test/example/du/
bats ../../mkdoc-make.bats
cd $MK_DIR/
bats test/mkdoc-make.bats


$ll attention $1 "Testing BM"
cd $MK_DIR/test/example/du/
bats ../../mkdoc-bm.bats


cd $MK_DIR
