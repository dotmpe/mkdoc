#!/usr/bin/env bash
#
### Greps rSt dependencies from file.
#
# References must be relative,
# to use absolute set RST_DOC_ROOT to the root directory
# for the current document.
#
# Dependencies searched for:
# - includes
# - images
# - references
# - raw file pass through
#
# Includes can be a named reference like <include.rst>
# to include a file from
# /usr/lib/python2.4/site-packages/docutils/parsers/rst/include

PERL_FIND_REFS='
use strict;
my $filename = shift;
open (FILE, "<", $filename)  or  die "Failed to read file $filename : $! \n";
my $whole_file;
{
	local $/;
	$whole_file = <FILE>;
}
close(FILE);
while ($whole_file =~ m#.. image::\ *[^\n]+\n\s+:(target):\s*([^\n]+)\n#sgi) {
	print $1 ." ". $2 . "\n";
}
while ($whole_file =~ m#.. raw::\ *[^\n]+\n\s+:(file|url):\s*([^\n]+)\n#sgi) {
	print "raw-".$1." ".$2. "\n";
}

'

### Main
docs=.rst-docs
echo $* > $docs

while test -s $docs; do

	# shift one row of docs
	doc=`head -1 $docs`
	cat $docs > .tmp
	l=`cat .tmp|wc -l`;
	tail -n `expr $l - 1` .tmp > $docs
	rm .tmp

	# XXX: ignores raw-url, inline references
	perl -e "$PERL_FIND_REFS" "$doc" > $doc.dep-matches
	#grep \.\.\ image\:\: $doc | sed 's/^.*\.\. image\:\:\ \+/image /g' >> $doc.dep-matches
	grep \.\.\ include\:\: $doc | sed 's/^.*\.\. include\:\:\ \+/include /g' >> $doc.dep-matches

	pwd=`realpath .`/
	local_dir=$(dirname "$doc")

	cat $doc.dep-matches | while read dep;
	  do
		f='';
		p=$(expr match "$dep" '\(raw-file\|raw-url\|target\|image\|include\)')
#		echo $p", "$dep
		# Matches for inclusion references (data is needed to build doctree)
		if test "$p" = "raw-file" -o "$p" = "include" -o "$p" = "target"; then
			f=${dep/"$p "/};
			if test ${f:0} != '/'; then
				f=$local_dir'/'$f;
			fi;
			# clean up path
            f=`realpath $f`;
			f=${f/$pwd/};
			# Report for each rSt include too..
			if test "${f##*.}" = 'rst'; then
				if test -s "$f"; then
					echo $f >> $docs;
				fi;
			fi;
		fi;
		# XXX: are images processed by docutils publisher? no?
#		if test "$p" = "image" ; then
#
#		else if test "$p" = "url"; then
#			echo;
#		fi;
		if test -n "$f"; then
			echo $f;
		fi;
	done;
	rm $doc.dep-matches;
done;
rm $docs
