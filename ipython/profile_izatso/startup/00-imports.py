"""Imports for ibots"""

import os
import re
import sys
import inspect

import bots
import bots
from bots.issues import issues

pyprint = print

mores = []

try:
    from rich.console import Console

    console = Console(color_system='standard')
    print = console.print
    mores += ['rich']
except ImportError:
    pass

try:
    from importlib import reload
except ImportError:

    def reload(x):
        raise NotImplementedError('importlib.reload is not available')


try:
    import requests

    mores += ['requests']
except ModuleNotFoundError:
    pass

try:
    import pysyte
    from pysyte.types import paths
    from pysyte.types.paths import path
    from pysyte import cli
except ImportError as e:
    print(e)
    sys.stderr.write('pip install pysyte # please')

try:
    from pathlib import Path

    mores += ['Path']
except ImportError:
    from pysyte.types.paths import path as Path


import zatso
import pym
copycat_=', copycat'
try:
    import copycat
except ImportError:
    copycat_=''


more = ', '.join([' '] + mores) if mores else ''
executable = sys.executable.replace(os.environ['HOME'], '~')
version = sys.version.split()[0]
stdout = lambda x: sys.stdout.write(f'{x}\n')

stdout(f'import os, re, sys, inspect, pysyte, paths, path, cli{more}')
stdout(f'import zatso, pym{copycat_}')
stdout('')
stdout(f'{executable} {version}')
stdout(f'{bots.__file__} {bots.__version__}')

def sys_argv():
    stdout = lambda x: sys.stdout.write(f'{x}\n')
    command, *args = sys.argv
    strings = ' '.join([f'"{_}"' for _ in args])
    stdout(f'$ {command} {strings}')
    stdout(f'')
