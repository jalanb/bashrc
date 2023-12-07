"""Imports for ipysyte"""

import os
import re
import sys
import inspect

pyprint = print

mores = []

try:
    import rich
    from rich import inspect
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
    from pysyte.types import trees
    mores += ["trees"]
except ImportError as e:
    print(e)
    sys.stderr.write("pip install trees # please")

try:
    from pathlib import Path

    mores += ["Path"]
except ImportError:
    from pysyte.types.paths import path as Path


sys_executable = sys.executable
sys_version    = sys.version
try:
    more = ", ".join([" "] + mores) if mores else ""
    sys.executable = sys.executable.replace(os.environ["HOME"], "~")
    sys.version = sys.version.split()[0]
    stdout = lambda x: sys.stdout.write(f"{x}\n")

    stdout(f"import os, re, sys, inspect{more}")
    stdout(f"import pysyte, paths, path, trees, cli")
    stdout("")
    stdout(f"{sys.executable=} {sys.version=}")
finally:
    sys.executable = sys_executable
    sys.version    = sys_version
