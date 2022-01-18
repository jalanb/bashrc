"""Imports for ibots"""

# pylint: disable=W0611

# import this

import os
import re
import sys
import inspect

import bots
<<<<<<< HEAD
from bots.issues import issues
=======
import tools
from tools.issues import issues
>>>>>>> 78e3db04 (Add new IPython profiles)

pyprint = print

mores = []

try:
    from rich.console import Console
    console = Console(color_system="standard")
    print = console.print
    mores += ["rich"]
except ImportError:
    pass

try:
    from importlib import reload
except ImportError:
    def reload(x):
        raise NotImplementedError("importlib.reload is not available")

try:
    import requests
    mores += ["requests"]
except ModuleNotFoundError:
    pass

try:
    import pysyte
    from pysyte.types import paths
    from pysyte.types.paths import path
    from pysyte import cli
except ImportError as e:
    print(e)
    sys.stderr.write("pip install pysyte # please")

try:
    from pathlib import Path
    mores += ["Path"]
except ImportError:
    from pysyte.types.paths import path as Path


<<<<<<< HEAD
=======
import zatso
import pym
import copycat

>>>>>>> 78e3db04 (Add new IPython profiles)



more = ", ".join([" "] + mores) if mores else ""
executable = sys.executable.replace(os.environ['HOME'], '~')
version = sys.version.split()[0]
stdout = lambda x: sys.stdout.write(f"{x}\n")

stdout(f"import os, re, sys, inspect, pysyte, paths, path, cli{more}")
<<<<<<< HEAD
stdout(f"import bots, bots.issues.issues")
=======
stdout(f"import zatso, pym, copycat")
>>>>>>> 78e3db04 (Add new IPython profiles)
stdout("")
stdout(f"{executable} {version}")
stdout(f"{bots.__file__} {bots.__version__}")
