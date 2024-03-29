"""Imports for IPython"""

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
    from rich import pretty

    pretty.install()
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
    pass

more = ", ".join([" "] + mores) if mores else ""
executable = sys.executable.replace(os.environ["HOME"], "~")
version = sys.version.split()[0]
stdout = lambda x: sys.stdout.write(f"{x}\n")

fred = "fred"
hello, world = "hello", "world"

stdout(f"import os, re, sys, inspect, pysyte, paths, path, cli{more}")

stdout("")
stdout(f"{executable} {version}")
