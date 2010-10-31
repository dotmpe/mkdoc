#!/usr/bin/env python
""" CatLink - Category Link
"""
import sys, os, optparse, hashlib
from os import sep, symlink, mkdir, rename
from os.path import expanduser, exists, isdir, isfile, \
        abspath, basename, dirname, join



def mkdirs(path):
    dirs = path.split(sep)
    exists = []
    while dirs:
        exists.append(dirs.pop(0))
        cpath = sep.join(exists)
        if cpath == '':
            cpath = sep
        if not isdir(cpath):
            mkdir(cpath)
    assert isdir(path)

def main():
    optprsr = optparse.OptionParser(usage='catlink [opts] src-path dest-path')
    optprsr.add_option('-n', '--no-act', action='store_true',
            default=False, help='default: %default')
    optprsr.add_option('-c', '--catalog', metavar='DIR',
            default=expanduser('~/catalog'),
            help='default: %default')
    opts, args = optprsr.parse_args()
    catalog = expanduser(opts.catalog)
    if not exists(catalog):
        optprsr.error('Catalog path must exist. ')
    if not isdir(catalog):
        optprsr.error('Catalog path must be directory. ')
    if not args:
        optprsr.error('Need two arguments: src-path dest-path. ')
    dest_path_orig = args[1]
    src_path, dest_path = map(abspath, map(expanduser,
        [args.pop(0), args.pop(0)]))
    if args:
        optprsr.error('Surplus arguments. ')
    if dest_path_orig[-1] == sep:
        dest_path += sep

    assert isfile(src_path)
    if dest_path[-1] == sep:
        dest_path += basename(src_path)
    if not opts.no_act and not exists(dest_path):
        dest_dir = dirname(dest_path)
        if dest_dir:
            mkdirs(dest_dir)
    assert not isfile(dest_path)
    sha1sum = hashlib.sha1(open(src_path).read()).hexdigest()
    if not opts.no_act:
        rename(src_path, dest_path)
    print "Moving <%s> to <%s>" % (src_path, dest_path)
    if not opts.no_act:
        open(dest_path+'.sha1sum', 'w').write(
            sha1sum+'  '+basename(dest_path)+'\n')
    catpath = list(sha1sum)
    for i in range(9, 0, -1):
        catpath.insert(i*4, sep)
    catpath = join(catalog, 
            ''.join(catpath))
    if not opts.no_act:
        mkdirs(dirname(catpath))
    print "Symlinking through <%s>" % catpath
    if not opts.no_act:
        symlink(dest_path, catpath)
        symlink(catpath, src_path)

if __name__ == '__main__':
    main()

