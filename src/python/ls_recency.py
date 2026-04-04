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
import re
import shutil
import subprocess
import sys
from datetime import datetime

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


def list_by_recency(directory: str, levels: int) -> list[tuple[str, float]]:
    """(name, mtime) pairs sorted by most recently changed first, ignores excluded"""
    spec = build_initial_spec(directory)
    local = os.path.join(directory, ".gitignore")
    if os.path.exists(local):
        spec = augment(spec, local)
    try:
        names = [n for n in os.listdir(directory) if not spec.match_file(n)]
    except OSError as e:
        print(e, file=sys.stderr)
        return []
    pairs = [
        (n, recency(os.path.join(directory, n), spec, levels)) for n in names
    ]
    pairs.sort(key=lambda x: x[1], reverse=True)
    return pairs


def age_group(mtime: float) -> tuple[int, str]:
    """Return (sort_key, label) classifying mtime into a human age bucket"""
    today = datetime.now().date()
    file_date = datetime.fromtimestamp(mtime).date()
    days = (today - file_date).days

    if days <= 0:
        return (0, "Today")
    if days == 1:
        return (1, "Yesterday")
    if days <= 7:
        return (days, f"{days} days ago")
    if days <= 13:
        return (8, "2 weeks ago")
    if days <= 20:
        return (9, "3 weeks ago")
    if days <= 27:
        return (10, "4 weeks ago")

    months = (today.year - file_date.year) * 12 + today.month - file_date.month
    months = max(months, 1)
    if months <= 12:
        label = "month" if months == 1 else "months"
        return (10 + months, f"{months} {label} ago")

    years = today.year - file_date.year
    if (today.month, today.day) < (file_date.month, file_date.day):
        years -= 1
    years = max(years, 1)
    label = "year" if years == 1 else "years"
    return (10 + 12 + years, f"{years} {label} ago")


def group_items(
    items: list[tuple[str, float]],
) -> list[tuple[str, list[str]]]:
    """Group (name, mtime) pairs into age buckets, preserving recency order within each"""
    seen: dict[int, tuple[str, list[str]]] = {}
    for name, mtime in items:
        key, label = age_group(mtime)
        if key not in seen:
            seen[key] = (label, [])
        seen[key][1].append(name)
    return [v for _, v in sorted(seen.items())]


_ANSI = re.compile(r"\x1b\[[0-9;]*[mK]")


def strip_ansi(s: str) -> str:
    return _ANSI.sub("", s)


def date_col(ls_line: str) -> int:
    """Character offset of the date field (month) in an ls -l output line"""
    plain = strip_ansi(ls_line)
    pos = 0
    for _ in range(5):  # skip: perms, links, owner, group, size
        while pos < len(plain) and plain[pos] == " ":
            pos += 1
        while pos < len(plain) and plain[pos] != " ":
            pos += 1
    while pos < len(plain) and plain[pos] == " ":
        pos += 1
    return pos


def now_str() -> str:
    """Current time formatted like ls -lh date column: 'Mar 30 09:15'"""
    now = datetime.now()
    return f"{now.strftime('%b')} {now.day:2d} {now.strftime('%H:%M')}"


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
    """List each directory's contents by recency, grouped by age"""
    for directory in directories:
        pairs = list_by_recency(directory, levels)
        if head:
            pairs = pairs[:head]
        elif tail:
            pairs = pairs[-tail:]

        groups = group_items(pairs)
        offset = 0
        first = True

        for label, names in groups:
            if long:
                full_paths = [
                    os.path.normpath(os.path.join(directory, n)) for n in names
                ]
                result = subprocess.run(
                    ["ls", "--color=always", "-lhdUF"] + full_paths,
                    capture_output=True,
                    text=True,
                )
                ls_lines = result.stdout.splitlines()
                if ls_lines and first:
                    offset = date_col(ls_lines[0])
                    print(" " * offset + now_str())
                    first = False
                print(f"\n{' ' * offset}{label}")
                print(result.stdout, end="")
            else:
                if not first:
                    print()
                print(label)
                first = False
                for name in names:
                    path = os.path.join(directory, name)
                    print(f"  {name}{classify(path)}")

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
