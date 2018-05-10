"""Imports for IPython"""

# pylint: disable-msg=W0611

# import this
from __future__ import print_function

import os
import re
import sys
import pysyte
import requests

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


print('import os, re, sys, pysyte, requests')
if see:
    print('from see import see, see_attributes, see_methods, spread')
    print('from see_code import code, highlight, see_code, see_highlight')
