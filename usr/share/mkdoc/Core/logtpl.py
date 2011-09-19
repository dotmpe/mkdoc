import logging
import os



def ansi_code(*digits):
    """
     0  20  reset
     1  21  bright on/off
     2  22  faint
     3  23  italic
     4  24  underlin
     5  25
     6  26  
     7  27  image negative
     8  28  conceal
     9  29  crossed-out 

     3*     foreground
     4*     background
      0
      1     red
      2     green
      3     yellow
      4     blue
      5     purple
      6     mint
      7     gray / white
      8            faint
    """
    return "\x1b[%sm" % ';'.join(map(str, digits))

CS = os.getenv('CS','dark')



INV="\x1b[40m"
if CS == 'dark':
    c0="\x1b[0;1;30m" # primary, hard black
    c7="\x1b[0;0;37m"
    c9="\x1b[1;1;37m"
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
        'tag': ansi_code(0,0,30),
        #'tag': c7,
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


# indent (whitespace), header, msg
N = "%(normal)s"
NORMAL = N+"%%s"
BLOCKSPAN = """%(sep)s[%(tag)s%%s%(sep)s]""" 
ANGLEDSPAN = """%(sep)s<%(tag)s%%s%(sep)s>""" 
HEADER = """%(tag)s%%s%(sep)s:""" 

PSEUDO_TARGET_MSG = N + ansi_code(0,7,30)+"test"+ansi_code(0,27,30)+" %%s  "+ BLOCKSPAN +' '+ NORMAL +' '+ ANGLEDSPAN + ansi_code(0,27,23)
FILE_TARGET_MSG = NORMAL + ANGLEDSPAN +' '+ NORMAL +' '+ ANGLEDSPAN + ansi_code(0,0,0)




