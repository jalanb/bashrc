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
from pysyte import scripts
from pysyte import text_streams
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


def add_args(parser):
    """Parse out command line arguments"""
    # parser.add_argument('source', help='path to source(s) to be checked')
    parser.add_argument('-c', '--clipboard', action='store_true',
                        help='Copy traceback lines from clipboard')
    parser.add_argument('-e', '--edit', action='store_true',
                        help='Show a vim command using tabs')
    parser.add_argument('-i', '--ipdb', action='store_true',
                        help='Show an ipdb command')
    parser.add_argument('-u', '--pudb', action='store_true',
                        help='Show a pudb command')
    parser.add_argument('-s', '--splits', action='store_true',
                        help='Show a vim command using splits')
    parser.add_argument('-y', '--pym', action='store_true',
                        help='Show a pym command')


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


def script(args):
    """Run the script"""
    stream = text_streams.first_argv('-c')
    if not stream:
        print('No file specified', file=sys.stderr)
        return not os.EX_OK
    lines = map(tracebacks.parse_line, text_streams.full_lines(stream))
    show([_ for _ in lines if _], args)
    return os.EX_OK


if __name__ == '__main__':
    scripts.main(script, add_args, __version__, __doc__)
