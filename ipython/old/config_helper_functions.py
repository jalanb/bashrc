"""Some config helper functions you can use"""

import sys
import os


import IPython.ipapi


def import_modules(modules):
    """ Usage: import_modules("os sys") """
    for module in modules.split():
        do_import('import %s' % module)


def import_all(modules):
    """ Usage: import_all("os sys") """
    for module in modules.split():
        do_import('from %s import *' % module)


def import_some(module, things):
    """Usage: import_some('path', 'path')"""
    for thing in things.split():
        do_import('from %s import %s' % (module, thing))


def do_import(import_line):
    try:
        ipython_api_execute(import_line)
        print >> sys.stdout, import_line
    except ImportError:
        print >> sys.stderr, 'Fail:', import_line


def execf(fname):
    """ Execute a file in user namespace """
    ipython_api_execute('execfile("%s")' % os.path.expanduser(fname))


def ipython_api():
    return IPython.ipapi.get()


def ipython_api_execute(command):
    ipython_api().ex(command)


def ipython_options():
    return ipython_api().options


def set_user_namespace(key, value):
    ipython_api().user_ns[key] = value
