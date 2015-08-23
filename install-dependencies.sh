#!/usr/bin/env bash

SRC_PREFIX=/tmp/src
PREFIX=~/usr

test -n "$SRC_PREFIX" || {
  echo "Not sure where checkout"
  exit 1
}

test -n "$PREFIX" || {
  echo "Not sure where to install"
  exit 1
}

# Check for BATS shell test runner or install
test -x "$(which bats)" && {
  bats --version
} || {
  echo "Installing bats"
  pushd $SRC_PREFIX
  git clone https://github.com/sstephenson/bats.git
  cd bats
  sudo ./install.sh $PREFIX
  popd
  bats --version
}

# Id: git-versioning/0.0.27-test install-dependencies.sh
