MkDoc
=====
:date: 2010-09-19
:update: 2010-10-16
:author: \B. van Berkum  <dev@dotmpe.com>
:homepage: http://dotmpe.com/project/mkdoc
:url: http://github.org/dotmpe/mkdoc/blob/master/usr/share/doc/mkdoc/README.rst
.. :url: http://github.org/dotmpe/mkdoc/blob/master/README.rst


A set of Makefiles:

- non-recursive use of make [#]_
- shared common recipes.

It is useful in quick bootstrapping of make rules, but I think it is the ugliest
code I have worked on. Nevertheless it is an nice exercise in Make+Bash scripting
but also leaves much to be desired.

Since this data is cross-linked and interdependent, the source and target paths
that are worked upon are referred to as mkdoc trees. 

I use this GNU/Make setup in individual software projects and in websites that 
(among others) include these projects. In fact, for websites I make it a point to 
only keep original content in the source trees, symlinking to content that is part 
of other projects or disk partitions.

.. [#] The non-recursive implementation is from `Implementing non-recursive make  <http://www.xs4all.nl/~evbergen/nonrecursive-make.html>`__, which tries to address the issues from `Recursive Make Considered Harmful  <http://miller.emu.id.au/pmiller/books/rmch/>`__. Obviously there are other solutions, possibly without boilerplate in sub-files. See e.g. `What is your experience with non-recursive make? <http://stackoverflow.com/questions/559216/what-is-your-experience-with-non-recursive-make>`__ or `Painless non-recursive Make <http://www.cmcrossroads.com/ask-mr-make/8133-painless-non-recursive-make>`__.

Usage
-----
The files in the root directory of this package (Makefile and Rules.mk) are
examples that bootstrap a project for use with mkdocs. Makefile can be
symlinked completely, but Rules.mk only provides the boilerplate to start adding 
build targets and their rules, prerequisites. Rules.mk should also include Makefiles
for subdirectories. By convention, these sub-makefiles are named:

- Rules.mk
- .Rules.mk
- Rules.$(HOST).mk
- .Rules.$(HOST).mk

The default rules generally keep this and generated content outside of the source-tree to keep the file-tree tidy.

.. admonition:: XXX
   
   The boostrap Makefile can be used from any (sub)directory. 
   But care should be taken so
   that dependences generated at this sub-level are usable at all levels up to
   the root. See on paths and dependencies.

The bootstrap Makefile has built-in special- or pseudo-targets to get started with
mkdocs. See ``make help``.

Required packages
-----------------
External tools may be required, see Makefile.
Recipes for the following are included by default:

- Docutils to generate content from reStructuredText.
- Tidy to validate, clean and pretty format HTML and XML documents.
- xsltproc for various document operations.
- build HaXe projects.
- build Bookmarklets (Javascript compiled into URIRefs).  

On paths and dependencies
-------------------------
In non-recursive make where rules are defined per directory and included in one
global Makefile, one may be tempted to aggregate one directory into several
projects or packages through symlinking. 
The intended result being less redundant storage of generated targets/documents.

Another goal is the relative ease in relocation directories within the tree.

Paths in dependency files should be rooted in one of the paths in VPATH, which
should be as little as possible. Obviously, at least the root of the project
package should be there. 

XXX: However the exact rules for generating hypertext targets are still a bit fuzzy.

XXX: obviously only one ROOT variable can be set for a global make system.
perhaps implement multiple roots using some hash table. It is therefore
recommended to keep dep paths absolute? 

XXX: By default the '/' root dir is also included. No sure if needed for
absolute paths?

