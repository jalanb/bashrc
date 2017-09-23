"""Script to edit a Python traceback

Re-format the file list as suitable for a vim list

Running the script like this
    python vim_traceback.py /path/to/traceback.log
Or like this
    python crappy_program.py | python ~/jab/src/python/vim_traceback.py

Will display a vim command to open all files mentioned in the traceback
    That command will open each file in a new tab on the correct line
    Note: if the file is in the traceback 5 times it will be opened in 5 tabs

If the code works for you, then try running the vim command directly:
    $(python vim_traceback.py /path/to/traceback.log)

If you prefer to use splits instead of tabs, add the option "-s", e.g
    $(python vim_traceback.py -s /path/to/traceback.log)

"""


from __future__ import print_function
import re
import os
import sys

from dotsite import text_streams
from dotsite import tracebacks


def as_vim_command(lines, use_splits):
    first, rest = lines[0], lines[1:]
    command = 'vim %s +%s' % first
    window = 'sp' if use_splits else 'tabnew'
    args = [str('+"%s +%s %s"' % (window, line, file_))
            for file_, line in rest]
    args.insert(0, command)
    return ' '.join(args)


def main(args):
    """Run the script"""
    args = [_ for _ in args if _[:2] != '--']
    stream = text_streams.first_argv('-c')
    if not stream:
        print('No file specified', file=sys.stderr)
        return not os.EX_OK
    lines = map(tracebacks.parse_line, text_streams.full_lines(stream))
    print(as_vim_command(lines, '-s' in args))
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
