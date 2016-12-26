MkDoc
=====
:version: 0.0.2-test+20150804-0404

:project:

  .. image:: https://secure.travis-ci.org/dotmpe/mkdoc.png
    :target: https://travis-ci.org/dotmpe/mkdoc
    :alt: Build

:repository:

  .. image:: https://badge.fury.io/gh/dotmpe%2Fmkdoc.png
    :target: http://badge.fury.io/gh/dotmpe%2Fmkdoc
    :alt: GIT


Quickstart
----------
::

  make -f Mkdocs-full.mk help

Link ``Makefile`` to `Mkdoc-full.mk` or `Mkdoc-minimal.mk`.
Development setups can link into ``mkdoc`` checkout.

- Write `Rules.*.mk` or `.Rules.*.mk`.
- Add targets to predefined vars (to use with ``make stat build test``)
- Use canned routines
- Or depend on predefined file patterns

Global vars and targets
  DMK (stat)
    Targets included as dynamic make definition files.
  DEP (stat)
    Other targets pre-requisite to stat.
  SRC (stat)
    Track all source files if wanted.
  TRGT (build)
    Build targets.
  TEST (test)
    Test targets.

For all lists::

  make lists

See project status see Travis CI build, and setup in ``.travis.yml``.


Install
-------

install::

  ./configure /usr/local && sudo ./install.sh


Test
-------

test::

  CS=dark PREFIX=/usr/local make -f Makefile.mkdoc test



see `usr/share/doc/mkdoc/README.rst <usr/share/doc/mkdoc/README.rst>`_
