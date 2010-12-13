#!/usr/bin/env python
"""
2010-12-13
    Simple hack to rewrite rST with includes.
"""
import os
import re
import sys

inputname = sys.argv[1]
doc = open(inputname).read()
os.chdir(os.path.dirname(inputname))
print >>sys.stderr,'cwd', os.getcwd()
print >>sys.stderr,inputname

#match_included = re.compile('^(\s*)\.\.\ include::\s*(.*)$',re.M)
match_included = re.compile('^\.\.\ include::\s*(.*)$',re.M)
# two pass, 
# 1. get filenames
find_includes = match_included.findall
includes = find_includes(doc)

def _repl(match):
    # FIXME: indent = match.group(1)
    included = open(match.group(1)).read()
    return included

# 2. replace with file contents

repl_includes = match_included.subn
newdoc, replacedcnt = repl_includes(_repl, doc)

print newdoc
