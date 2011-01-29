MkDoc
=====
:date: 2010-09-19
:update: 2010-12-04
:author: \B. van Berkum  <dev@dotmpe.com>
:homepage: http://dotmpe.com/project/mkdoc
:url: http://github.org/dotmpe/mkdoc/blob/master/usr/share/doc/mkdoc/README.rst

.. :url: http://github.org/dotmpe/mkdoc/blob/master/README.rst


A set of Makefiles:

- non-recursive use of make [#]_
- shared common recipes.

.. admonition:: Some kind of disclaimer

   It is useful in quick bootstrapping of make rules, but I think it is the ugliest
   code I have worked on. Nevertheless it is an nice exercise in Make+Bash scripting
   but also leaves much to be desired (example: I just noted $(eval) may help in
   streamlining current recipes and rules further). It probably is not getting more
   legible though.

   I use these myself whenever I need to grab to GNU/Make for automation.
   So there are quite some projects using this, I myself have found every day
   use for it.


Objectives are primarily building of document contents, and offering a toolkit
for various operations in Makefiles.
There is a framework to define special targets in place, used by `Rules.default.mk`__.
Also an external script does formatting and colored output.

.. __: usr/share/mkdoc/Core/Rules.default.mk

I use this GNU/Make setup in individual software projects and in websites that 
(among others) include these projects. Ideally, content has only one specific
location. Pieces written for a website reside in a (project) directory for that
website, while notes included in the website may be part of other project
directires (symlinked).

Since the data (SRC/TRGT/.. sets) are cross-linked and interdependent, 
the paths that are worked upon are referred to as mkdoc trees. 

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

Other ToDo, ideas
-----------------
- Fix `make pub`
- Use `tee` somehow to write error logs for targets?
- Fix processing so included files/dependencies are also 'fully' processed, ie.
  KEYWORDS expanded, etc.

