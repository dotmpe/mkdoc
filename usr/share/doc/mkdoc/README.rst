MkDoc
=====
:date: 2010-09-19
:update: 2012-04-05
:author: \B. van Berkum  <dev@dotmpe.com>
:homepage: http://dotmpe.com/project/mkdoc
:url: http://github.org/dotmpe/mkdoc/blob/master/usr/share/doc/mkdoc/README.rst

.. :url: http://github.org/dotmpe/mkdoc/blob/master/README.rst


A set of Makefiles:

- non-recursive use of make [#]_, ie. does not restart a Make session for every
  directory encountered.
- share common recipes.

.. admonition:: Some kind of disclaimer

   It is useful in quick bootstrapping of make rules, but I think it is the ugliest
   code I have worked on. Nevertheless it is an nice exercise in Make+Bash scripting
   though it leaves much to be desired. Legibility will be hard to improve upon.
   
   I use these myself whenever I need to grab GNU Make for automation.
   So there are quite some projects using this, I myself have found every day
   use for it.

Objectives are primarily building of documents, and offering a Make/Bash toolkit.

There is a framework to define special targets in place, implemented by 
`Rules.default.mk`__.
There is also formatting and colored output.

.. __: usr/share/mkdoc/Core/Rules.default.mk

.. [#] The non-recursive implementation is from `Implementing non-recursive make  <http://www.xs4all.nl/~evbergen/nonrecursive-make.html>`__, which tries to address the issues from `Recursive Make Considered Harmful  <http://miller.emu.id.au/pmiller/books/rmch/>`__. Obviously there are other solutions, possibly without boilerplate in sub-files. See e.g. `What is your experience with non-recursive make? <http://stackoverflow.com/questions/559216/what-is-your-experience-with-non-recursive-make>`__ or `Painless non-recursive Make <http://www.cmcrossroads.com/ask-mr-make/8133-painless-non-recursive-make>`__.

Usage
-----
The files in the root directory of this package (Makefile and Rules.mk) are
examples that bootstrap a project for use with mkdocs. This Makefile can be
symlinked completely, but the Rules.mk only provides the boilerplate for a new 
project with mkdoc trees and you chould copy end edit it.

Once I prepared my projects it looks a bit like this::

  my-project/
  ├── .Rules.mk
  ├── Makefile -> /usr/share/mkdoc/Makefile
  └── media
      └── Rules.mk

Ofcourse, mkdoc may be located elsewhere.

Now `make` may be run from the main directory. If needed, you may write 
your Rules.mk recipes such that you can also run `make` from any subdirectory. 
Just make an extra symlink to Makefile to start. These directories are principal
entry points and will be called **mkdocs (main) session directories**.
They are the root point of the relative paths in the current build.

The Rules.mk in Makefile directory will included automatically upon running
make from that directory. Note that each directory has at most one such primary 
Rules.mk that is auto-included. Not every directory in the project may need one. 

By convention, these sub-makefiles are named:

- Rules.mk
- .Rules.mk
- Rules.$(HOST).mk
- .Rules.$(HOST).mk

This means the primary Rules can be switched when needed on a per-host basis.
The convention is implemented in the GNU Make function 'rules', which you can
call yourself. You *should* do this to include further (sub) directories. For 
this do::

  DIR = my/sub/dir
  include $(call rules,$(DIR)/)

Further note the pro- and epilogue of the Rules.mk, which keeps global stack
variables, which you do not need to touch. It uses the stack to keep the 
following make variables available in each Rules.mk:

$d
  The current directory, relative to the `mkdocs session directory`.
  Without trailing slash.
$/
  As '$d', but with trailing slash.
   
The default rules generally keep generated content outside of the source-tree to keep the file-tree tidy. There are two options built-in to separate generated files:

$B
  The BUILD directory paired with the current directory, relative to the 
  *mkdocs session directory*.
$b
  The BUILD directory relative to the *current* directory.

.. admonition:: XXX
   
   The boostrap Makefile can be used from any (sub)directory. 
   But care should be taken so
   that dependences generated at this sub-level are usable at all levels up to
   the root. mkdocs does not offer an off-the-shelve solution.
   See `On paths and dependencies`_.

The bootstrap Makefile has built-in special- or pseudo-targets to get started with
mkdocs. See ``make help`` to get started.

Since the data (SRC/TRGT/.. sets) are cross-linked and interdependent, 
the paths that are worked upon are referred to as mkdoc trees. 

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

mkdocs Branches
---------------

Other ToDo, ideas
-----------------
- Fix `make pub`
- Use `tee` somehow to write error logs for targets?
- Fix processing so included files/dependencies are also 'fully' processed, ie.
  KEYWORDS expanded, etc.

