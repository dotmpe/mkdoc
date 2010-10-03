#!/usr/bin/perl
#
# http://daringfireball.net/2007/03/javascript_bookmarklet_builder
# http://faq.perl.org/perlfaq6.html#How_do_I_use_a_regul
#
#
use strict;
use warnings;
use URI::Escape qw(uri_escape_utf8);
use open  IO  => ":utf8",       # UTF8 by default
          ":std";               # Apply to STDIN/STDOUT/STDERR
use Getopt::Std;

my %options=();
getopts("d", \%options);

my $src = do { local $/; <> };
my $bm = $src;

$bm =~ s{^\s*//.*\n}{}gm;  # Kill all line comments.

# Take a good shot at C comments
$bm =~ s#/\*[^*]*\*+([^/*][^*]*\*+)*/|("(\\.|[^"\\])*"|'(\\.|[^'\\])*'|.[^/"'\\]*)#defined $2 ? $2 : ""#gse; 

$bm =~ s{\t}{ }gm;         # Tabs to space
$bm =~ s{\n}{ }gm;          # Newlines to space
$bm =~ s{\ +}{ }gm;        # Space runs to one space
#$bm =~ s{\n}{}gm;          # Kill newlines
# Remove various whitespaces
$bm =~ s{; }{;}gm;
$bm =~ s{, }{,}gm;
$bm =~ s{ ?\} ?}{\}}gm;
$bm =~ s{ ?\{ ?}{\{}gm;
$bm =~ s{^\s+}{}gm;        # Kill line-leading whitespace
$bm =~ s{\s+$}{}gm;        # Kill line-ending whitespace

if (!defined $options{d})
{
# Escape single- and double-quotes, spaces, control chars, unicode, <, >, \, /,
$bm = uri_escape_utf8($bm, qq('" \x00-\x1f\x7f-\xff\x3c\x3e\\\\\/));
$bm =~ s{%27}{'}gm;          # Unescape single-quotes
}

print $bm . $/;
