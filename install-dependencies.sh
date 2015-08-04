#!/usr/bin/env bash

DIR=$1

test -n "$DIR" || DIR=$HOME

test -n "$DIR" || {
  echo "Not sure where to install"
  exit 1
}

# Check for BATS shell test runner or install
test -x "$(which bats)" && {
  bats --version
} || {
  echo "Installing bats"
  pushd $DIR
  git clone https://github.com/sstephenson/bats.git
  cd bats
  sudo ./install.sh /usr/local
  popd
  bats --version
}

# Id: git-versioning/0.0.27-test install-dependencies.sh
