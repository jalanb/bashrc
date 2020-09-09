"""Imports for IPython"""

# pylint: disable-msg=W0611

# import this

import os
import re
import sys
import inspect

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
except ImportError as e:
    print(e)
    sys.stderr.write("pip install pysyte # please")

try:
    from pathlib import Path
except ImportError:
    from pysyte.types.paths import path as Path


import bots
import tools



more = ", ".join([""] + mores) if mores else ""
executable = sys.executable.replace(os.environ['HOME'], '~')
version = sys.version.split()[0]
stdout = lambda x: sys.stdout.write(f"{x}\n")

stdout(f"import os, re, sys, inspect, pysyte, paths, path{more}")
stdout(f"import bots, tools")
stdout("")
stdout(f"{executable} {version}")
