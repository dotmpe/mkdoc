MkDoc
=====
:date: 2010-09-19
:update: 2013-11-19
:author: \B. van Berkum  <dev@dotmpe.com>
:url: http://github.org/dotmpe/mkdoc/blob/master/usr/share/doc/mkdoc/README.rst

.. :url: http://github.org/dotmpe/mkdoc/blob/master/README.rst


A set of Makefiles:

- non-recursive use of make [#]_, ie. does not restart a Make session for every
  directory encountered.
- share common recipes across projects.

.. admonition:: Some kind of disclaimer

   It is useful in quick bootstrapping of make rules, but I think it is the ugliest
   code I have worked on. Nevertheless it is flexible and a defacto build standard.
   Legibility will be hard to improve upon, but there is imho no substitute.
   
Objectives are primarily building of documents, 
and a Make/Bash toolkit to manage file(-operation)s of various sorts.

Quickstart
----------
There are two parts. The 'Main' files which include all reusable variables,
functions and canned recipes.
The 'Rules' files provide the actual implicit and explicit make rules.

To supplement this, a root makefile that can simply be linked into the project 
does the actual loading of all shared and local Rules files.
There is a framework that uses some special variables, implemented in `Rules.default.mk`__.
These are notably 'build' and 'clean' that work on the global vars TRGT and CLN
resp. See also 'help'.

.. __: usr/share/mkdoc/Core/Rules.default.mk

.. [#] The non-recursive implementation is from `Implementing non-recursive make  <http://www.xs4all.nl/~evbergen/nonrecursive-make.html>`__, which tries to address the issues from `Recursive Make Considered Harmful  <http://miller.emu.id.au/pmiller/books/rmch/>`__. Obviously there are other solutions, possibly without boilerplate in sub-files. See e.g. `What is your experience with non-recursive make? <http://stackoverflow.com/questions/559216/what-is-your-experience-with-non-recursive-make>`__ or `Painless non-recursive Make <http://www.cmcrossroads.com/ask-mr-make/8133-painless-non-recursive-make>`__.

Usage
-----
::

  cd ~/myproject
  /usr/share/mkdoc/invade
  make

Or as I usually do it::

  cd ~/myproject
  mv Makefile Rules.old.mk # to be copied manually to new Rules.mk
  ln -s /usr/share/mkdoc/Mkdocs.full
  cp /usr/share/mkdoc/Rules.mk Rules.mk 

Then edit away.

Once prepared a projects may look like this::

  my-project/
  ├── .Rules.mk
  ├── Makefile -> /usr/share/mkdoc/Makefile
  └── media
      └── Rules.mk

`make` may be run from the main directory.

Depnding on use it may be convienient to run from subdirectories, just make an extra symlink there. 
These directories are principal entry points and the path is referred to as the session path.
They are the root point of the relative paths in the current build, 
This may affect build results, see notes on BUILD later on.

This is how Mkdics.full starts looking for Rule files:

- Rules.mk
- .Rules.mk
- Rules.$(HOST).mk
- .Rules.$(HOST).mk

This means the primary Rules can be switched when needed on a per-host basis.

The convention is implemented in the GNU Make function 'rules', which you can
call yourself. This is used to include further (sub) directories::

  DIR = my/sub/dir
  include $(call rules,$(DIR)/)

Note the pro- and epilogue of the Rules.mk, which keeps global stack
variables, which you do not need to touch. It uses a stack to keep the 
following make variables available in each Rules.mk:

$d
  The current directory, relative to the `mkdocs session directory`.
  Without trailing slash.
$/
  As '$d', but with trailing slash.
   
The default rules generally focus to keep generated content outside of the source-tree to keep the file-tree tidy. 
There is a special variable BUILD, which indicate what the prefix is to the target paths.

There gives two options built-in to separate target (session-path+BUILD prefix) from source files (session path):

$B
  The BUILD directory paired with the current directory, relative to the 
  *mkdocs session directory*.
$b
  The BUILD directory relative to the *current* directory.

The bootstrap Makefile has built-in special- or pseudo-targets to get started with
mkdocs. See ``make help`` to get started.

Note the following variables::


Thats all for now. Some more notes follow.

XXX: In non-recursive make where rules are defined per directory and included in one
global Makefile, one may be tempted to think of grand build schemes and lookk
toward sharing and compenentization of various sources, buildable targets and
recipes.
The intended result being less redundant storage of generated targets/documents,
another trying to take benefit and learn of componentization and microformats.

XXX: obviously only one ROOT variable can be set for a global make system.
perhaps implement multiple roots using some hash table. It is therefore
recommended to keep dep paths absolute? 

XXX: By default the '/' root dir is also included. No sure if needed for
absolute paths?

XXX: Make, especially in a non-recursive setting take a start up penalty depending on
their size.
This means a session must do as much as possible in one run to be usefull.
This is somewhat in contrast with other command-line tool filosophies which work far faster (though perhaps I'm just spoiled with GIT).
But it is safe to say builds, especially involving many files get costly.
So it presents with some challenges, not all which can be overcome easily.
Dependencies may only be known after some intial parsing, publishing, etc.
This is why the PENDING list was introduced.

TODO: But that should be fixed. A proper interaction or SRC with DEP and DMK may eliminate the need for PENDING?

This is the normal sequence:

SRC can contain source files, though afaicr it is not usefull other than for statistics?
And ofcourse it is normally the case that the TRGT paths are build from the SRC
paths.

DEP and DMK are almost the same. DEP is generated from source files for other
targets to use, ie. cached (meta)data.
DMK are dynamic make files which are build from SRC and DEP before being loaded as makefile.

Then TRGT is the list of actual files generated on 'make build'.


Required packages
-----------------
External tools may be required, see Makefile.
Recipes for the following are included by default:

- Docutils to generate content from reStructuredText.
- Tidy to validate, clean and pretty format HTML and XML documents.
- xsltproc for various document operations.
- build HaXe projects.
- build Bookmarklets (Javascript compiled into URIRefs).  




mkdocs Branches
---------------
Generic branches:

master
    Main development.
devel
    Non stable in working stuff, but better than experimental.
    Read branch docs.

    mayflower
      development branch (temporarily) started may 2012 (back to devel again in
      autumn). 
      
experimental
    As it says. Temporary maybe, but read branch docs.

Topic branches:

dev_packages
    Trying to introduce sub packages of mkdocs.

Other ToDo, ideas
-----------------
- Fix `make pub`
- Use `tee` somehow to write error logs for targets?
- Fix processing so included files/dependencies are also 'fully' processed, ie.
  KEYWORDS expanded, etc.

