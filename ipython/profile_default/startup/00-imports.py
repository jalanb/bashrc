"""Imports for IPython"""

# pylint: disable-msg=W0611

# import this

import os
import re
import sys
import inspect
try:
    from importlib import reload
except ImportError:
    def reload(x):
        raise NotImplementedError("importlib.reload is not available")

mores = []

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
    try:
        import dotsite as pysyte
    except ImportError:
        sys.stderr.write("pip install pysyte # please")

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

pyprint = print

try:
    from rich.console import Console
    console = Console(color_system="standard")
    print = console.print
    mores += ["rich"]
except ImportError:
    pass




more = ", ".join([" "] + mores) if mores else ""
executable = sys.executable.replace(os.environ['HOME'], '~')
version = sys.version.split()[0]
stdout = lambda x: sys.stdout.write(f"{x}\n")

stdout(f"import os, re, sys, inspect, pysyte, paths, path, cli{more}")
stdout("")
stdout(f"{executable} {version}")
