#!/usr/bin/env python
"""

Requirements
------------
1. Tag conforms to ID format.
2. Tag is used in prefixed form, preceded by single or multi character sequence.
3. Find lines with this tag.

   1. Read value for tag (text).

      * Read to line-end and subsequent indented lines.
      * Continue line to '.' for tags halfway in text, or scan for assigned
        brackets.

   2. Record location of new tag, its value and assign ID or number.

   3. Link to tag.

     * Location (File/Line/Character) suffices for static files.
     * Dynamic files are modified to include tag ID or number.

4. Update value/location for tag.

   * Sync to db.
   * Sync to file.

"""


example_doc = """

TODO: new todo line

TODO:483987: Line
  Continued

  Broken

  TODO:1234: Line
    Continued
Embedded tags such as FIXME:find a reference. may be used too.    

@TODO:6234:[His real name is Frank]
#list:123:[In unmarked trucks across the country]
:list: :123:[In unmarked trucks across the country]

"""

TAG = 'TODO'
TAG_PREFIX = '@'
TAG_BRACKETS = '[]'
TAG_ID_GENERATOR = None


def scan_text(f, src_id='<src>'):
    tags = {}
    
    return tags

def scan_file(f, src_id=None):
    if not src_id and hasattr(f, 'name'):
        src_id = f.name
    if not hasattr(f, 'read'):
        data = open(f).read()
    else:        
        data = f.read()
    return scan_text(data, src_id=src_id)


# Main
tags = scan_text()
if fn in db:
    pass

