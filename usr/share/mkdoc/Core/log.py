#!/usr/bin/env python
import os
CS = os.getenv('CS','dark')

if CS == 'dark':
    c0="\x1b[0;1;30m" # primary, hard black
    c7="\x1b[0;0;37m"
    c9="\x1b[0;1;37m"
elif CS == 'light':
    # primary, black
    c0="\x1b[0;0;30m"
    # pale (inverted white)
    c7="\x1b[0;0;30m"
    # hard (bright black, ie. dark gray)
    c9="\x1b[0;1;30m"
c1="\x1b[0;1;31m" # red
c2="\x1b[0;1;32m" # green
c3="\x1b[0;1;33m" # yellow
c4="\x1b[0;1;34m" # blue


def m(d1,d2):
    d1 = d1.copy()
    d1.update(d2)
    return d1

palette = {
        'normal': c7,
        'bold': c9,
        'sep': c9,
        'tag': c0,
    }
green = m(palette,{
        'sep': c2,
        #'tag': c4,
    })
blue = m(palette,{
        'sep': c4,
    })
red = m(palette,{
        'sep': c1,
    })
yellow = m(palette,{
        'sep': c3,
    })

def mk_psuedo_target_message(target, msg='', colours=palette):
    msg += '. '
    indent = (16 - len(target)) * ' '
    s = (
    """%(normal)s%%s%(sep)s[%(tag)s%%s%(sep)s] %(normal)s%%s""" % colours
        ) % (indent, target, msg)
    return s,

def mk_done(target, msg='', colours=green):
    if msg:
        msg = ', '+msg
    msg = ( "%(bold)sDone%(normal)s%%s" % colours ) % msg
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_ok(target, msg='', colours=green):
    if msg:
        msg = ', '+msg
    msg = ( "%(bold)sOK%(normal)s%%s" % colours ) % msg
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_header1(label, msg='', colours=blue):
    indent = (16 - len(label)) * ' '
    s = ( 
    """%(normal)s%%s%(tag)s%%s%(sep)s: %(bold)s%%s%(normal)s""" % colours
        ) % (indent, label, msg)
    return s,

def mk_header2(label, msg='', colours=blue):
    indent = (16 - len(label)) * ' '
    s = (
    """%(bold)s%%s%(tag)s%%s%(sep)s: %(normal)s%%s""" % colours
        ) % (indent, label, msg)
    return s,

def mk_info(target, msg='', colours=blue):
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_debug(target, msg='', colours=yellow):
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_warning(target, msg='', colours=yellow):
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_error(target, msg='', colours=red): 
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_fatal(target, msg='', colours=red): 
    return mk_psuedo_target_message(target, msg, colours=colours)


state = {
        'done': mk_done,
        'ok': mk_ok,
        'header': mk_header1,
        'header1': mk_header1,
        'header2': mk_header2,
        'debug': mk_debug,
        'warning': mk_warning,
        'error': mk_error,
        'fatal': mk_fatal,
    }


if __name__ == '__main__':
    import sys
    args = sys.argv[1:]
    if sys.argv[0] == '-':
        lines = sys.stdin.readlines()
        for line in lines:
            line = line.split('\t')
            print ' '.join(state[line[0]](*line[1:]))
    else:
        print ' '.join(state[args[0]](*args[1:]))

