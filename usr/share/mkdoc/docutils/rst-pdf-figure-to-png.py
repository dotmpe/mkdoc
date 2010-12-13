#!/usr/bin/env python
"""
2010-12-13
    Even more hacky, I need .pdf -> .png for XHTML output.
    Doing it in document rather than connect since .pdf is not valid for <img />
"""
import os
import re
import sys


# XXX:
figstmt = 'figuur'

docname = sys.argv[1]
assert os.path.exists(docname) and os.path.isfile(docname), docname
doc = open(docname).read()

do_replace = re.compile('^(\s*)\.\.\ ('+figstmt+')::\s*(.*)$', re.M).subn

def _repl(match):
    indent = match.group(1)
    tp = match.group(2)
    imgname = match.group(3)
    if imgname.endswith('.pdf'):
        imgname = imgname[:-4] + '.png'
    return "%s.. %s:: %s" % (indent, tp, imgname)

newdoc, replcnt = do_replace(_repl, doc)

print newdoc
print >>sys.stderr, "Replaced %i occurrences. "%replcnt

