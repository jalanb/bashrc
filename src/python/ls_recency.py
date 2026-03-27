#! /usr/bin/env python3
"""List directory items ordered by most recently changed

Level 1: items ordered by modification time, most recent first
Level 2: a directory's recency is the max mtime of any item within it,
         not the directory's own mtime

Ignores files/dirs matching patterns from ~/.gitignore_global,
the git root's .gitignore, and any .gitignore found while descending.
"""

import argparse
import bdb
import os
import shutil
import subprocess
import sys

import pathspec


def git_root(path: str) -> str:
    """Git root above path, or empty string if not in a repo"""
    status, output = subprocess.getstatusoutput(
        f"git -C {path!r} rev-parse --show-toplevel"
    )
    return output.strip() if status == 0 else ""


def load_spec(path: str) -> pathspec.PathSpec:
    """Load a .gitignore-style file into a PathSpec, or empty spec on error"""
    try:
        with open(path) as f:
            return pathspec.PathSpec.from_lines("gitwildmatch", f)
    except OSError:
        return pathspec.PathSpec([])


def augment(base: pathspec.PathSpec, gitignore_path: str) -> pathspec.PathSpec:
    """Return a new PathSpec combining base patterns with those from gitignore_path"""
    extra = load_spec(gitignore_path)
    return pathspec.PathSpec(base.patterns + extra.patterns)


def build_initial_spec(directory: str) -> pathspec.PathSpec:
    """Build ignore spec from ~/.gitignore_global and the git root .gitignore"""
    spec = load_spec(os.path.expanduser("~/.gitignore_global"))
    root = git_root(directory)
    if root:
        spec = augment(spec, os.path.join(root, ".gitignore"))
    return spec


def file_recency(path: str) -> float:
    """Modification time of a file, or 0.0 on error"""
    try:
        return os.path.getmtime(path)
    except OSError:
        return 0.0


def dir_recency(path: str, spec: pathspec.PathSpec, levels: int) -> float:
    """Most recent mtime of any non-ignored item under a directory

    levels controls recursion depth: 0 means unlimited, 1 means this dir only,
    N means recurse N levels deep.
    """
    local = os.path.join(path, ".gitignore")
    if os.path.exists(local):
        spec = augment(spec, local)
    best = file_recency(path)
    try:
        for entry in os.scandir(path):
            if spec.match_file(entry.name):
                continue
            try:
                if entry.is_dir(follow_symlinks=False):
                    if levels == 1:
                        t = file_recency(entry.path)
                    else:
                        next_levels = levels - 1 if levels > 1 else 0
                        t = dir_recency(entry.path, spec, next_levels)
                else:
                    t = entry.stat(follow_symlinks=False).st_mtime
            except OSError:
                t = 0.0
            if t > best:
                best = t
    except OSError:
        pass
    return best


def recency(path: str, spec: pathspec.PathSpec, levels: int) -> float:
    """Recency of path: dirs use deepest-modified child, files use own mtime"""
    if os.path.isdir(path):
        return dir_recency(path, spec, levels)
    return file_recency(path)


def list_by_recency(directory: str, levels: int) -> list[str]:
    """Names in directory sorted by most recently changed first, ignores excluded"""
    spec = build_initial_spec(directory)
    local = os.path.join(directory, ".gitignore")
    if os.path.exists(local):
        spec = augment(spec, local)
    try:
        names = [n for n in os.listdir(directory) if not spec.match_file(n)]
    except OSError as e:
        print(e, file=sys.stderr)
        return []
    paths = sorted(
        (os.path.join(directory, n) for n in names),
        key=lambda p: recency(p, spec, levels),
        reverse=True,
    )
    return [os.path.basename(p) for p in paths]


def default_n_lines() -> int:
    """90% of terminal height, falling back to 20 lines"""
    lines = shutil.get_terminal_size().lines
    return int(lines * 0.9) if lines > 0 else 20


def classify(path: str) -> str:
    """Append '/' for dirs, '*' for executables, else empty string"""
    if os.path.isdir(path):
        return "/"
    if os.access(path, os.X_OK):
        return "*"
    return ""


def script(
    directories: list[str], levels: int, long: bool, head: int, tail: int
) -> int:
    """List each directory's contents by recency"""
    for directory in directories:
        items = list_by_recency(directory, levels)
        if head:
            items = items[:head]
        elif tail:
            items = items[-tail:]
        if long:
            full_paths = [
                os.path.normpath(os.path.join(directory, item)) for item in items
            ]
            subprocess.run(["ls", "-lhdUF"] + full_paths)
        else:
            for item in items:
                path = os.path.join(directory, item)
                print(f"{item}{classify(path)}")
    return os.EX_OK


def parse_args() -> argparse.Namespace:
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "directories",
        metavar="DIR",
        nargs="*",
        default=["."],
        help="directories to list (default: .)",
    )
    parser.add_argument(
        "-l",
        "--long",
        action="store_true",
        help="long listing, like ls -lh",
    )
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        "-H",
        "--head",
        type=int,
        nargs="?",
        const=0,
        default=None,
        metavar="N",
        help="show first N items (default: 90%% of terminal height)",
    )
    group.add_argument(
        "-T",
        "--tail",
        type=int,
        nargs="?",
        const=0,
        default=None,
        metavar="N",
        help="show last N items (default: 90%% of terminal height)",
    )
    parser.add_argument(
        "-L",
        "--level",
        type=int,
        default=2,
        metavar="N",
        help="recursion depth for recency (default: 2, 0 = unlimited)",
    )
    return parser.parse_args()


def main() -> int:
    """Run the script"""
    try:
        args = parse_args()
        if args.level < 0:
            print(f"error: --level must be >= 0, got {args.level}", file=sys.stderr)
            return os.EX_USAGE
        default = default_n_lines()
        head = default if args.head == 0 else (args.head or 0)
        tail = default if args.tail == 0 else (args.tail or 0)
        return script(args.directories, args.level, args.long, head, tail)
    except bdb.BdbQuit:
        return os.EX_OK
    except KeyboardInterrupt:
        return os.EX_OK


if __name__ == "__main__":
    sys.exit(main())
