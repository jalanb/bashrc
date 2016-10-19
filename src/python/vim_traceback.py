"""Script to parse a Python traceback

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


import re
import os
import sys

from dotsite import text_streams


def line_regexp():
    """Regular expression to match a traceback file line"""
    return re.compile(r'''\s*
        File\s
        (
            (
                ["']
                (?P<path_to_python>[^"']+)
                ["']
            ) | (
                (?P<spaceless_path_to_python>[^ ]+)
            )
        )
        ,\sline\s
        (?P<line_number>[0-9]+)
        ,.in..*
    ''', re.VERBOSE)


def parse_line(string):
    """Parse a single string as traceback line"""
    match = line_regexp().match(string)
    if match:
        matches = match.groupdict()
        line_number = matches['line_number']
        path_to_python = matches['path_to_python']
        spaceless_path_to_python = matches['spaceless_path_to_python']
        if path_to_python:
            return path_to_python, line_number
        elif spaceless_path_to_python:
            return spaceless_path_to_python, line_number


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
        print >> sys.stderr, 'No file specified'
        return not os.EX_OK
    lines = [parse_line(l) for l in text_streams.full_lines(stream)]
    lines = [l for l in lines if l]
    print as_vim_command(lines, '-s' in args)
    return os.EX_OK


if __name__ == '__main__':
    # try:
    sys.exit(main(sys.argv[1:]))
    # except (IndexError, AttributeError):
    #    import pudb
    #    pudb.post_mortem()
