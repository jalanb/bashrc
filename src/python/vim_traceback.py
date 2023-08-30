"""Script to edit a Python traceback

Re-format the file list as suitable for a vim list

Running the script like this
    python vim_traceback.py /path/to/traceback.log
Or like this
    python fred.py 2> >(python ~/jab/src/python/vim_traceback.py -)

Will display a vim command to open all files mentioned in the traceback
    That command will open each file in a new tab on the correct line
    Note: if the file is in the traceback 5 times it will be opened in 5 tabs

If the code works for you, then try running the vim command directly:
    $(python vim_traceback.py /path/to/traceback.log)

If you prefer to use splits instead of tabs, add the option "-s", e.g
    $(python vim_traceback.py -s /path/to/traceback.log)

"""


import os
import sys

from pysyte.cli import arguments
from pysyte.cli import streams
from pysyte.tracebacks import parse_line


def parse_args():
    """Parse out command line arguments"""
    parser = arguments.parser(__doc__)
    parser.positional("logs", help="logs to use")
    parser.boolean("s", "splits", help="use splits, not tabs, in vim")
    parser.boolean("i", "stdin", help="wait for text from stdin")
    return parser.parse_args()


def as_vim_command(lines, use_splits):
    try:
        first, rest = lines[0], lines[1:]
    except IndexError:
        raise ValueError(f"{lines=}")
    command = 'vim %s +%s' % first
    window = 'sp' if use_splits else 'tabnew'
    args = [str('+"%s +%s %s"' % (window, line, file_))
            for file_, line in rest]
    args.insert(0, command)
    return " ".join(args)


def main(args):
    """Run the script"""
    args = parse_args()
    for stream in streams.args(args, "logs"):
        parsed = [parse_line(_) for _ in stream.readlines()]
        lines = [_ for _ in parsed if _]
        if not lines:
            from rich import inspect
            inspect(stream)
            continue
        try:
            print(as_vim_command(lines, args.splits))
        except ValueError:
            print(f"{stream=}\n{parsed=}\n{lines=}")
        print
    return os.EX_OK


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
