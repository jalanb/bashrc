"""Script to handle a Python traceback

Running the script like this
    python tracebacks.py -v /path/to/traceback.log
Or like this
    python crappy_program.py | python ~/jab/src/python/tracebacks.py -v

Will display a vim command to open all files mentioned in the traceback
    That command will open each file in a new tab on the correct line
    Note: if the file is in the traceback 5 times it will be opened in 5 tabs

If the code works for you, then try running the vim command directly:
    $(python tracebacks.py -v /path/to/traceback.log)

If you prefer to use splits instead of tabs, add the option "-s", e.g
    $(python tracebacks.py -v -s /path/to/traceback.log)

"""


from __future__ import print_function
import os
import sys

from pysyte import debuggers
from pysyte.cli import streams
from pysyte import tracebacks


__version__ = '0.1.0'


def as_vim_command(lines, use_splits):
    first, rest = lines[0], lines[1:]
    command = 'vim %s +%s' % first
    window = 'sp' if use_splits else 'tabnew'
    args = [str('+"%s +%s %s"' % (window, line, file_))
            for file_, line in rest]
    args.insert(0, command)
    return ' '.join(args)


def parse_args():
    """Parse out command line arguments"""
    parser = arguments.parser(__doc__)
    parser.positional('file', help='File with traceback data')
    parser.boolean('', 'edit', help='Show a vim command using tabs')
    parser.boolean('', 'splits', help='Show a vim command using splits')
    parser.boolean('d', 'ipdb', help='Show an ipdb command')
    parser.boolean('u', 'pudb', help='Show a pudb command')
    parser.boolean('y', 'pym', help='Show a pym command')
    parser.boolean('', 'paste', help='Paste text from clipboard')
    parser.boolean('i', 'stdin', help='Wait for text from stdin')
    return parser.parse_args()


def show(lines, args):
    debuggers.break_ere()
    if args.edit:
        print(as_vim_command(lines, '-s' in args))
        return
    if args.pudb:
        debugger = debuggers.PudbDebugger()
    elif args.ipdb:
        debugger = debuggers.IpdbDebugger()
    else:
        debugger = debuggers.pymdbDebugger()
    debugger.add_breaks(lines)


def main(args):
    """Run the script"""
    args = parse_args()
    streams = streams.args(args, 'file')
    if not streams:
        print('No file specified', file=sys.stderr)
        return not os.EX_OK
    lines = map(tracebacks.parse_line, streams.full_lines(streams[0]))
    show([_ for _ in lines if _], args)
    return os.EX_OK


def main():
    script(args)
    return 0


if __name__ == '__main__':
    sys.exit(main())
