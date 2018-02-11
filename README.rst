MkDoc
=====
:version: 0.0.2-test+20150804-0404

:created: Sept. 2010

:project:

  .. image:: https://secure.travis-ci.org/bvberkum/mkdoc.png
    :target: https://travis-ci.org/bvberkum/mkdoc
    :alt: Build

:repository:

  .. image:: https://badge.fury.io/gh/bvberkum%2Fmkdoc.png
    :target: http://badge.fury.io/gh/bvberkum%2Fmkdoc
    :alt: GIT


For project status see `Travis CI build`__, or setup in ``.travis.yml``.

.. __: https://travis-ci.org/bvberkum/mkdoc


Quickstart
----------
See::

  make -f Mkdocs-full.mk help

or::

  cd <my-project>
  ln -s /usr/local/share/mkdoc/Mkdoc-full.mk Makefile

  # Put local targets and recipes in Rules.mk:
  touch .Rules.mk
  #touch .Rules.<hostname>.mk
  #touch Rules.mk

- Use `Mkdoc-full.mk` to get all targets and libs, or FIXME: `Mkdoc-minimal.mk`
  to get minimal libs and targets, XXX: or define your own build/test/install/...?
- Write either `Rules.*.mk` or `.Rules.*.mk`.
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


Install
-------
install (or upgrade)::

  ./configure /usr/local && sudo ./install.sh
  ./configure /usr/local && sudo ./install.sh uninstall install


Test
-------

test::

  CS=dark PREFIX=/usr/local make -f Makefile.mkdoc test



see `usr/share/doc/mkdoc/README.rst <usr/share/doc/mkdoc/README.rst>`_
