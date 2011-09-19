#!/usr/bin/env python
import os
import sys
import logging

import logtpl



def mk_(header, linetpl, colours):
    """
    Function generator. Create function to write colored line with header.
    """
    def func(target, msg):
        msg += '. '
        indent = (16 - len(target)) * ' '
        return linetpl % colours % (indent, target, msg)
    return func


def mk_psuedo_target_message(target, msg='', colours=logtpl.palette):
    s = logtpl.PSEUDO_TARGET_MSG % colours % (indent, target, msg)
    return s,

def mk_file_target_message(target, msg='', colours=logtpl.palette):
    msg += '. '
    indent = (16 - len(target)) * ' '
    s = logtpl.FILE_TARGET_MSG % colours % (indent, target, msg)
    return s,

def mk_done(target, msg='', colours=logtpl.green):
    if msg:
        msg = ', '+msg
    msg = logtpl.DONE_MSG % colours % msg
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_ok(target, msg='', colours=logtpl.green):
    if msg:
        msg = ', '+msg
    msg = ( "%(bold)sOK%(normal)s%%s" % colours ) % msg
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_header1(label, msg='', colours=logtpl.blue):
    indent = (16 - len(label)) * ' '
    s = ( 
    """%(normal)s%%s%(tag)s%%s%(sep)s: %(bold)s%%s%(normal)s""" % colours
        ) % (indent, label, msg)
    return s,

def mk_header2(label, msg='', colours=logtpl.blue):
    indent = (16 - len(label)) * ' '
    s = (
    """%(bold)s%%s%(tag)s%%s%(sep)s: %(normal)s%%s""" % colours
        ) % (indent, label, msg)
    return s,

def mk_info(target, msg='', colours=logtpl.blue):
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_debug(target, msg='', colours=logtpl.yellow):
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_warning(target, msg='', colours=logtpl.yellow):
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_error(target, msg='', colours=logtpl.red): 
    return mk_psuedo_target_message(target, msg, colours=colours)

def mk_fatal(target, msg='', colours=logtpl.red): 
    return mk_psuedo_target_message(target, msg, colours=colours)


state = {
        # Standard log levels
#        'info': log_info,
#        'debug': log_debug,
#        'warning': log_warning,
#        'error': log_error,
#        'critical': log_critical,

        # mkdoc log records/argument-templates
#        'file_rule': mk_fil,
        'special_rule': mk_psuedo_target_message,
        'ok': mk_ok,
        'done': mk_done,
        'header': mk_header1,
        'header1': mk_header1,
        'header2': mk_header2,
#        'debug': mk_debug,
#        'warning': mk_warning,
#        'error': mk_error,
#        'fatal': mk_fatal,
    }

## {{{ http://code.activestate.com/recipes/474089/ (r2)
# xlog.py


# Adding the 'username' and 'funcname' specifiers
# They must be attributes of the log record

# Custom log record
class MkLogRecord(logging.LogRecord):
    #def __init__(self, name, level, pathname, lineno, msg, args, exc_info, func=None):
    def __init__(self, *args, **kwargs):
        logging.LogRecord.__init__(self, *args, **kwargs)
        self.username = current_user()
        self.funcname = calling_func_name()
        #self.source_files = []

# Custom logger that uses our log record
class MkLogger(logging.getLoggerClass()):
    #def makeRecord(self, name, level, fn, lno, msg, args, exc_info, func=None, extra=None):
    def makeRecord(self, *args, **kwargs):
        return MkLogRecord(*args, **kwargs)

# Register our logger
#logging.setLoggerClass(MkLogger)
logger = logging.getLogger('mkdoc')

#logging.basicConfig( format="%(filename)s: %(username)s says '%(message)s' in %(funcname)s" )

class MkLogFormat(logging.Formatter):
    pass


# Current user
def current_user():
    try:
        return pwd.getpwuid(os.getuid()).pw_name
    except KeyError:
        return "(unknown)"

# Calling Function Name
def calling_func_name():
    return calling_frame().f_code.co_name

def calling_frame():
    f = sys._getframe()

    while True:
        if is_user_source_file(f.f_code.co_filename):
            return f
        f = f.f_back

def is_user_source_file(filename):
    return os.path.normcase(filename) not in (_srcfile, logging._srcfile)

def _current_source_file():
    if __file__[-4:].lower() in ['.pyc', '.pyo']:
        return __file__[:-4] + '.py'
    else:
        return __file__

_srcfile = os.path.normcase(_current_source_file())


handler = logging.StreamHandler(sys.stderr)
#FULL_RECORD = """%(name)s %(levelname)s %(asctime)s <%(filename)s:%(lineno)s> %(module)s.%(funcName)s [%(processName)s %(process)s %(thread)i] %(msg)s"""

FULL_RECORD = """%(name)s %(levelname)s %(asctime)s %(msg)s"""
T = logtpl.PSEUDO_TARGET_MSG % logtpl.yellow % ("%(asctime)s", "%(name)s", "%(msg)s", "")
handler.setFormatter(MkLogFormat(T))
logger.addHandler(handler)

logger.info("A message.")
logger.debug("A message.")
logger.error("A message.")
logger.warning("A message.")
logger.critical("A message.")


## end of http://code.activestate.com/recipes/474089/ }}}

#if __name__ == '__main__':
#    args = sys.argv[1:]
#    if sys.argv[0] == '-':
#        lines = sys.stdin.readlines()
#        for line in lines:
#            line = line.split('\t')
#            print ' '.join(state[line[0].lower()](*line[1:]))
#    else:
#        print ' '.join(state[args[0].lower()](*args[1:]))

