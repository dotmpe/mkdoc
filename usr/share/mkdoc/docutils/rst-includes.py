#!/usr/bin/env python
"""
2010-12-13
	Simple hack to rewrite rST with includes.
2010-12-15
	Upgraded script to have target argument and better output control.
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


# 0. parse argv

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

#match_included = re.compile('^(\s*)\.\.\ include::\s*(.*)$',re.M)
match_included = re.compile('^\.\.\ include::\s*(.*)$',re.M)
# two pass, 
# 1. get filenames
find_includes = match_included.findall
includes = find_includes(doc)

def _repl(match):
	incres = match.group(1).strip()
	if (incres[0], incres[-1]) == ('<','>'):
		return ".. include:: %s " % incres
	# FIXME: indent = match.group(1)
	included = open(incres).read()
	return included

# 2. replace with file contents

repl_includes = match_included.subn
newdoc, replcnt = repl_includes(_repl, doc)

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
