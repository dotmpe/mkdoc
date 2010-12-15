#!/usr/bin/env python
"""
2010-12-13
    Even more hacky, I need .pdf -> .png for XHTML output.
    Doing it in document rather than connect since .pdf is not valid for <img />
2010-12-15
	Upgraded script to have target argument and better output control.
	Sees a generic rSt directive rewriter might give this script a valid focus.
"""
import os
from os.path import isfile, isdir, dirname, basename
import re
import sys


CHATTER = 1 # not muted or quiet, but essentials only

ERR_001 = "Surplus arguments %s" 
ERR_002 = "Target directory does not exist: %s"
ERR_003 = "Will not write to same output as input file: %s"
ERR_004 = "Source file does not exist: %s" 
ERR_005 = "Source is not a file: %s" 

# XXX:
figstmt = 'figuur'

inputname = sys.argv[1]
assert os.path.exists(inputname), ERR_005 % inputname
assert os.path.isfile(inputname), ERR_004 % inputname
doc = open(inputname).read()
if sys.argv[1:]:
	targetname = sys.argv[2]
	assert not sys.argv[3:], ERR_001 % sys.argv[2:]
	assert isfile(targetname) or (not dirname(targetname) or isdir(dirname(targetname))), ERR_002 % targetname
else:
	targetname = None
# refuse to write to same source file, even if current impl. is compatible	
assert inputname != targetname, ERR_003 % targetname
# work from input source directory
pwd = os.getcwd()
docdir = dirname(inputname)
if docdir:
	os.chdir(dirname(inputname))
if CHATTER > 2:	
	print >>sys.stderr, 'cwd', pwd
	print >>sys.stderr, inputname

# 2. rewrite statements

do_replace = re.compile('^(\s*)\.\.\ ('+figstmt+')::\s*(.*)$', re.M).subn

def _repl(match):
    indent = match.group(1)
    tp = match.group(2)
    imgname = match.group(3)
    if imgname.endswith('.pdf'):
        imgname = imgname[:-4] + '.png'
    return "%s.. %s:: %s" % (indent, tp, imgname)

newdoc, replcnt = do_replace(_repl, doc)

# 3. Output

os.chdir(pwd)

MSG_TRGT = "Written contents to %s"
MSG_RPL = "Replaced %i occurences" 

if targetname:
	open(targetname, 'w+').write(newdoc)
	if CHATTER > 1:
		print MSG_TRGT % targetname
	if CHATTER:
		print MSG_RPL % replcnt
else:
	if CHATTER:
		print >>sys.stderr, MSG_RPL % replcnt
	print newdoc


# vim:noet:

