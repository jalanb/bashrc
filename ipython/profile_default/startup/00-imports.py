"""Imports for IPython"""

# pylint: disable-msg=W0611

import this
print

import os
import re
import sys
print 'import os, re, sys'

from path import path
from dotsite.paths import makepath
print 'from dotsite.paths import path, makepath'
from see import see
from see import see_attributes
from see import see_methods
from see import spread
print 'from see import see, see_attributes, see_methods, spread'
from see_code import code
from see_code import highlight
from see_code import see_code
from see_code import see_highlight
print 'from see_code import code, highlight, see_code, see_highlight'
