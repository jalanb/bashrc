"""Imports for IPython"""

# pylint: disable-msg=W0611

# import this

import os
import re
import sys

import requests

try:
    import pysyte
except ImportError as e:
    try:
        import dotsite as pysyte
    except ImportError:
        sys.stderr.write('pip install pysyte # please')

try:
    from pathlib import Path
except ImportError:
    try:
        from pysyte.types.paths import path as Path
    except ImportError:
        if sys.version_info.major == 2:
            from dotsite.paths import path as Path
        else:
            raise

try:
    from see import see
    from see import see_attributes
    from see import see_methods
    from see import spread
    from see_code import code
    from see_code import highlight
    from see_code import see_code
    from see_code import see_highlight
except ImportError:
    see = False


def line(s):
    sys.stdout.write('%s\n' % s)

line('import os, re, sys, pysyte, requests')
if see:
    line('from see import see, see_attributes, see_methods, spread')
    line('from see_code import code, highlight, see_code, see_highlight')

line('')
line('%s %s' % (
    sys.executable.replace(os.environ['HOME'], '~'), sys.version.split()[0]))
