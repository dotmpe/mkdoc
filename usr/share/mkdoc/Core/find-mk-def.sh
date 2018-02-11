#!/bin/sh

set -e

# Variables (or macro) come as recursively expanded or simply expanded.
# Additionally ?= and += are special recursively expanded.
# And multilines can be declared for both types too.
# This gives two patterns for matching all variable (and macro) declarations:

# <var> [:+?]=
# define <var> [:+?]=t


ARG="${MK}"
test -n "$ARG" || ARG="${MK_SHARE-.}"

grep -srIn "^$1\s*[:\?\+]\?=" $ARG || nosrc1=$?
grep -srIn "^define $1\s*\([:\?\+]=\)\?$" $ARG || nosrc2=$?

test -z "$nosrc1" -o -z "$nosrc2"
