#!/usr/bin/env python
""" Catalog - keep links unbroken.

The catalog directory contains an index of SHA1 sums, each symlinked to the
mediafile the SHA1 sum belongs to.  Within the document body, links to these
mediafiles are made to these 'catalog paths'. This means that when the file is
gone, the identity is retained through the SHA1 sum.

Directories that are sources of mediafiles are to be passed
on the command line as arguments and ordered to priority.

Whenever the mediafile is missing or moved, this script may attempt to relink to
an existing source.

TODO: not working, see catlink for quickhack

Requirements
  - Multiple mediafiles allowed per catalog entry.
  - Having *.sha1sum files along the mediafiles safes from hashing again.
  - Checksum mode enables a full integrity check of the archived mediafiles.

"""
import sys, os, optparse, hashlib, anydbm


class Index(object):
    def __init__(self, index):
        self.index = index

    def close(self):
        self.index.close()

    def add_root(self, dirpath):
        assert os.path.isdir(dirpath)
        assert dirpath not in self.index
        k = '__ROOT__'
        if k not in self.index:
            i = 1
        else:
            i = int(self.index[k]) + 1
        self.index[k+str(i)] = dirpath
        self.index[k] = str(i)
        self.index[dirpath] = '0,0,0'

    def add_dir(self, dirpath):
        assert os.path.isdir(dirpath)
        assert dirpath not in self.index
        p = os.path.dirname(dirpath)
        pt, pd, pf = self.get(p)
        self.index[p+str(i)] = dirpath
        self.index[dirpath] = '0,0,0'

    @property
    def roots(self):
        k = '__ROOT__'
        for i in range(1, int(self.index[k])+1):
            yield self.index[k+str(i)]

    def __setitem__(self, directory, args):
        if directory not in self.index:
            self.add_dir(directory)
        self.index[directory] = ','.join(map(str, args))

    def __getitem__(self, dirpath):
        return map(int, self.index[dirpath].split(','))

    def update(self, dirpath):
        dircnt = 0
        filecnt = 0
        for root, dirs, files in os.walk(dirpath):
            curdir = os.path.join(dirpath, root)
            newtime = int(os.path.getmtime(curdir))
            self[curdir] = newtime, len(dirs), len(files)


def init_db(path):
    if not os.path.exists(path):
        db = anydbm.open(path, 'n')
    else:
        db = anydbm.open(path, 'w')
    return Index(db)

def proc_args():
    optprsr = optparse.OptionParser()
    optprsr.add_option('-c', '--catalog', metavar='DIR',
            default=os.path.expanduser('~/catalog'),
            help='default: %default')
    optprsr.add_option('-i', '--index', metavar='DBFILE',
            default='index.db',
            help='default: %default')
    optprsr.add_option('-l', '--list', action='store_true')
    opts, args = optprsr.parse_args()

    CATALOG = opts.catalog
    assert os.path.exists(CATALOG) and os.path.isdir(CATALOG)

    INDEX = os.path.join(CATALOG, opts.index)
    db = init_db(INDEX)

    if opts.list:
        for k in db.index:
            print k, db.index[k]
        exit(1)

    if '-' in args or '--' in args:
        print >>sys.stderr,"Reading from stdin"
        for path in sys.stdin.readlines():
            # XXX: when does the loop stop?
            if path not in db.index:
                db.add_root(path)
            else:
                print >>sys.stderr, "Root exists: %s" % path
    else:
        print >>sys.stderr,"Reading from arguments"
        for path in args:
            if path not in db.index:
                db.add_root(path)
            else:
                print >>sys.stderr, "Root exists: %s" % path

    return db

def main():
    db = proc_args()
    for root in db.roots:
        lasttime, dircount, filecount = db[root]
        curtime = int(os.path.getmtime(root))
        if lasttime < curtime:
            print >>sys.stderr, "Updating %s" % root
            db.update(root)
    db.close()

if __name__ == '__main__':
    main()

